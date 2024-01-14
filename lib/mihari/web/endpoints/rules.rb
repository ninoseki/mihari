# frozen_string_literal: true

module Mihari
  module Web
    module Endpoints
      #
      # Rule API endpoint
      #
      class Rules < Grape::API
        class RuleCreateUpdater < Service
          #
          # @params [String] yaml
          # @params [Boolean] overwrite
          #
          # @return [Mihari::Models::Rule]
          #
          def call(yaml, overwrite: true)
            rule = Rule.from_yaml(yaml)

            # To invoke ActiveRecord::RecordNotFound
            Models::Rule.find(rule.id) if overwrite

            raise IntegrityError, "ID:#{rule.id} already registered" if rule.exists? && !overwrite

            rule.update_or_create
            rule
          end
        end

        namespace :rules do
          desc "List/search rules", {
            is_array: true,
            success: Entities::RulesWithPagination,
            summary: "List/search rules"
          }
          params do
            optional :q, type: String, default: ""
            optional :page, type: Integer, default: 1
            optional :limit, type: Integer, default: 10
          end
          get "/" do
            value = Services::RuleSearcher.call(params.to_h)
            present({
              results: value.results,
              total: value.total,
              current_page: value.filter[:page].to_i,
              page_size: value.filter[:limit].to_i
            },
              with: Entities::RulesWithPagination)
          end

          desc "Get a rule", {
            success: Entities::Rule,
            failure: [{ code: 404, model: Entities::ErrorMessage }],
            summary: "Get a rule"
          }
          params do
            requires :id, type: String
          end
          get "/:id" do
            id = params[:id].to_s
            result = Services::RuleGetter.result(params[:id].to_s)
            return present(result.value!, with: Entities::Rule) if result.success?

            case result.failure
            when ActiveRecord::RecordNotFound
              error!({ message: "ID:#{id} not found" }, 404)
            end
            raise result.failure
          end

          desc "Search by a rule", {
            success: { code: 201, model: Entities::QueueMessage },
            failure: [{ code: 404, model: Entities::ErrorMessage }],
            summary: "Run a rule"
          }
          params do
            requires :id, type: String
          end
          post "/:id/search" do
            status 201

            id = params[:id].to_s

            queued = true
            result = Dry::Monads::Try[StandardError] do
              rule = Mihari::Rule.from_model(Mihari::Models::Rule.find(id))

              if Mihari.sidekiq?
                Jobs::SearchJob.perform_async(rule.id)
              else
                rule.call
                queued = false
              end
            end.to_result

            message = queued ? "ID:#{id}'s search is queued" : "ID:#{id}'s search is successful"
            return present({ message: message, queued: queued }, with: Entities::QueueMessage) if result.success?

            case result.failure
            when ActiveRecord::RecordNotFound
              error!({ message: "ID:#{id} not found" }, 404)
            end
            raise result.failure
          end

          desc "Create a rule", {
            success: { code: 201, model: Entities::Rule },
            failure: [
              { code: 400, model: Entities::ErrorMessage },
              { code: 422, model: Entities::ErrorMessage }
            ],
            summary: "Create a rule"
          }
          params do
            requires :yaml, type: String, documentation: { param_type: "body" }
          end
          post "/" do
            status 201

            yaml = params[:yaml].to_s

            result = RuleCreateUpdater.result(yaml, overwrite: false)
            return present(result.value!.model, with: Entities::Rule) if result.success?

            failure = result.failure
            case failure
            when Psych::SyntaxError
              error!({ message: failure.message }, 422)
            when ValidationError
              error!({ message: "Rule format invalid", detail: failure.errors.to_h }, 422)
            when IntegrityError
              error!({ message: failure.message }, 400)
            end
            raise failure
          end

          desc "Update a rule", {
            success: { code: 201, model: Entities::Rule },
            failure: [
              { code: 404, model: Entities::ErrorMessage },
              { code: 422, model: Entities::ErrorMessage }
            ],
            summary: "Update a rule"
          }
          params do
            requires :yaml, type: String, documentation: { param_type: "body" }
          end
          put "/" do
            status 201

            yaml = params[:yaml].to_s

            result = RuleCreateUpdater.result(yaml, overwrite: true)
            return present(result.value!.model, with: Entities::Rule) if result.success?

            failure = result.failure
            case failure
            when ActiveRecord::RecordNotFound
              error!({ message: "Rule not found" }, 404)
            when Psych::SyntaxError
              error!({ message: failure.message }, 422)
            when ValidationError
              error!({ message: "Rule format invalid", detail: failure.errors.to_h }, 422)
            end
            raise failure
          end

          desc "Delete a rule", {
            success: { code: 204, model: Entities::Message },
            failure: [{ code: 404, model: Entities::ErrorMessage }],
            summary: "Delete a rule"
          }
          params do
            requires :id, type: String
          end
          delete "/:id" do
            status 204

            id = params[:id].to_s
            result = Services::RuleDestroyer.result(id)
            return present({ message: "ID:#{id} is deleted" }, with: Entities::Message) if result.success?

            case result.failure
            when ActiveRecord::RecordNotFound
              error!({ message: "ID:#{id} not found" }, 404)
            end
            raise result.failure
          end
        end
      end
    end
  end
end
