# frozen_string_literal: true

module Mihari
  module Web
    module Endpoints
      #
      # Rule API endpoint
      #
      class Rules < Grape::API
        class RuleGetter < Service
          #
          # @params [String] id
          #
          # @return [Mihari::Models::Rule]
          #
          def call(id)
            Mihari::Models::Rule.find id
          end
        end

        class RuleRunner < Service
          #
          # @param [String] id
          #
          def call(id)
            rule = Mihari::Rule.from_model(Mihari::Models::Rule.find(id))
            rule.call
          end
        end

        class RuleCreator < Service
          #
          # @params [String]
          #
          # @return [Mihari::Models::Rule]
          #
          def call(yaml)
            rule = Rule.from_yaml(yaml)

            found = Mihari::Models::Rule.find_by_id(rule.id)
            error!({ message: "ID:#{rule.id} is already registered" }, 400) unless found.nil?

            rule.model.save
            rule
          end
        end

        class RuleUpdater < Service
          #
          # @params [String] id
          # @params [String] yaml
          #
          # @return [Mihari::Models::Rule]
          #
          def call(id:, yaml:)
            Mihari::Models::Rule.find(id)

            rule = Rule.from_yaml(yaml)
            rule.model.save
            rule
          end
        end

        class RuleDestroyer < Service
          #
          # @param [String] id
          #
          def call(id)
            Mihari::Models::Rule.find(id).destroy
          end
        end

        namespace :rules do
          desc "Search rules", {
            is_array: true,
            success: Entities::RulesWithPagination,
            summary: "Search rules"
          }
          params do
            optional :q, type: String, default: ""
            optional :page, type: Integer, default: 1
            optional :limit, type: Integer, default: 10
          end
          get "/" do
            value = Services::RuleSearcher.call(params.to_h)
            present({
              rules: value.results,
              total: value.total,
              current_page: value.filter[:page].to_i,
              page_size: value.filter[:limit].to_i
            },
              with: Entities::RulesWithPagination)
          end

          desc "Get a rule", {
            success: Entities::Rule,
            failure: [{ code: 404, model: Entities::Message }],
            summary: "Get a rule"
          }
          params do
            requires :id, type: String
          end
          get "/:id" do
            id = params[:id].to_s
            result = RuleGetter.result(params[:id].to_s)
            return present(result.value!, with: Entities::Rule) if result.success?

            case result.failure
            when ActiveRecord::RecordNotFound
              error!({ message: "ID:#{id} is not found" }, 404)
            end
            raise result.failure
          end

          desc "Run a rule", {
            success: { code: 201, model: Entities::Message },
            failure: [{ code: 404, model: Entities::Message }],
            summary: "Run a rule"
          }
          params do
            requires :id, type: String
          end
          get "/:id/run" do
            status 201

            id = params[:id].to_s
            result = RuleRunner.result(id)
            return present({ message: "ID:#{id}} has been ran" }, with: Entities::Message) if result.success?

            case result.failure
            when ActiveRecord::RecordNotFound
              error!({ message: "ID:#{id} is not found" }, 404)
            end
            raise result.failure
          end

          desc "Create a rule", {
            success: { code: 201, model: Entities::Rule },
            failure: [{ code: 404, model: Entities::Message }],
            summary: "Create a rule"
          }
          params do
            requires :yaml, type: String, documentation: { param_type: "body" }
          end
          post "/" do
            status 201

            result = RuleCreator.result(params[:yaml])
            return present(result.value!.model, with: Entities::Rule) if result.success?

            failure = result.failure
            case failure
            when Psych::SyntaxError
              error!({ message: failure.message }, 400)
            when ValidationError
              error!({ message: "Rule format is invalid", details: failure.errors.to_h }, 400)
            end
            raise failure
          end

          desc "Update a rule", {
            success: { code: 201, model: Entities::Rule },
            failure: [{ code: 404, model: Entities::Message }],
            summary: "Update a rule"
          }
          params do
            requires :id, type: String, documentation: { param_type: "body" }
            requires :yaml, type: String, documentation: { param_type: "body" }
          end
          put "/" do
            status 201

            id = params[:id].to_s
            result = RuleUpdater.result(id: id, yaml: params[:yaml].to_s)
            return present(result.value!.model, with: Entities::Rule) if result.success?

            failure = result.failure
            case failure
            when ActiveRecord::RecordNotFound
              error!({ message: "ID:#{id} is not found" }, 404)
            when Psych::SyntaxError
              error!({ message: failure.message }, 400)
            when ValidationError
              error!({ message: "Rule format is invalid", details: failure.errors.to_h }, 400)
            end
            raise failure
          end

          desc "Delete a rule", {
            success: { code: 204, model: Entities::Message },
            failure: [{ code: 404, model: Entities::Message }],
            summary: "Delete a rule"
          }
          params do
            requires :id, type: String
          end
          delete "/:id" do
            status 204

            id = params[:id].to_s
            result = RuleDestroyer.result(id)
            return present({ message: "ID:#{id} is deleted" }, with: Entities::Message) if result.success?

            case result.failure
            when ActiveRecord::RecordNotFound
              error!({ message: "ID:#{id} is not found" }, 404)
            end
            raise result.failure
          end
        end
      end
    end
  end
end
