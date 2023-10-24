# frozen_string_literal: true

module Mihari
  module Endpoints
    class Rules < Grape::API
      namespace :rules do
        desc "Get Rule IDs", {
          is_array: true,
          success: Entities::RuleIDs,
          summary: "Get rule IDs"
        }
        get "/ids" do
          rule_ids = Mihari::Models::Rule.distinct.pluck(:id)
          present({ rule_ids: rule_ids }, with: Entities::RuleIDs)
        end

        desc "Search rules", {
          is_array: true,
          success: Entities::RulesWithPagination,
          failure: [{ code: 404, message: "Not found", model: Entities::Message }],
          summary: "Search rules"
        }
        params do
          optional :page, type: Integer, default: 1
          optional :limit, type: Integer, default: 10

          optional :title, type: String
          optional :description, type: String
          optional :tag, type: String

          optional :fromAt, type: DateTime
          optional :toAt, type: DateTime
        end
        get "/" do
          filter = params.to_h.to_snake_keys

          # normalize keys
          filter["tag_name"] = filter["tag"]
          # symbolize hash keys
          filter = filter.to_h.symbolize_keys

          search_filter_with_pagenation = Structs::Filters::Rule::SearchFilterWithPagination.new(**filter)
          rules = Mihari::Models::Rule.search(search_filter_with_pagenation)
          total = Mihari::Models::Rule.count(search_filter_with_pagenation.without_pagination)

          present(
            { rules: rules,
              total: total,
              current_page: filter[:page].to_i,
              page_size: filter[:limit].to_i },
            with: Entities::RulesWithPagination
          )
        end

        desc "Get a rule", {
          success: Entities::Rule,
          failure: [{ code: 404, message: "Not found", model: Entities::Message }],
          summary: "Get a rule"
        }
        params do
          requires :id, type: String
        end
        get "/:id" do
          extend Dry::Monads[:result, :try]

          id = params["id"].to_s

          result = Try do
            Mihari::Models::Rule.find(id)
          end.to_result

          return present(result.value!, with: Entities::Rule) if result.success?

          failure = result.failure
          case failure
          when ActiveRecord::RecordNotFound
            error!({ message: "ID:#{id} is not found" }, 404)
          else
            raise failure
          end
        end

        desc "Run a rule", {
          success: Entities::Message,
          summary: "Run a rule"
        }
        params do
          requires :id, type: String
        end
        get "/:id/run" do
          extend Dry::Monads[:result, :try]

          id = params["id"].to_s

          result = Try do
            Mihari::Services::RuleProxy.from_model(Mihari::Models::Rule.find(id))
          end.to_result

          if result.success?
            result.value!.analyzer.run
            status 201
            return present({ message: "ID:#{id} is ran successfully" }, with: Entities::Message)
          end

          failure = result.failure
          case failure
          when ActiveRecord::RecordNotFound
            error!({ message: "ID:#{id} is not found" }, 404)
          else
            raise failure
          end
        end

        desc "Create a rule", {
          success: Entities::Rule,
          summary: "Create a rule"
        }
        params do
          requires :yaml, type: String, documentation: { param_type: "body" }
        end
        post "/" do
          extend Dry::Monads[:result, :try]

          yaml = params[:yaml]
          result = Try do
            Services::RuleProxy.from_yaml(yaml)
          end.to_result.bind do |rule|
            Try do
              found = Mihari::Models::Rule.find_by_id(rule.id)
              error!({ message: "ID:#{rule.id} is already registered" }, 400) unless found.nil?
              rule
            end.to_result
          end.bind do |rule|
            Try do
              rule.model.save
              rule
            end.to_result
          end

          if result.success?
            status 201
            return present(result.value!.model, with: Entities::Rule)
          end

          failure = result.failure
          case failure
          when Psych::SyntaxError
            error!({ message: failure.message }, 400)
          when ValidationError
            error!({ message: "Data format is invalid", details: failure.errors.to_h }, 400)
          else
            raise failure
          end
        end

        desc "Update a rule", {
          success: Entities::Rule,
          summary: "Update a rule"
        }
        params do
          requires :id, type: String, documentation: { param_type: "body" }
          requires :yaml, type: String, documentation: { param_type: "body" }
        end
        put "/" do
          extend Dry::Monads[:result, :try]

          id = params[:id]
          yaml = params[:yaml]

          result = Try do
            Mihari::Models::Rule.find(id)
          end.to_result.bind do |_|
            Try do
              Services::RuleProxy.from_yaml(yaml)
            end.to_result
          end.bind do |rule|
            Try do
              rule.model.save
              rule
            end.to_result
          end

          if result.success?
            status 201
            return present(result.value!.model, with: Entities::Rule)
          end

          failure = result.failure
          case failure
          when ActiveRecord::RecordNotFound
            error!({ message: "ID:#{id} is not found" }, 404)
          when Psych::SyntaxError
            error!({ message: failure.message }, 400)
          when ValidationError
            error!({ message: "Data format is invalid", details: failure.errors.to_h }, 400)
          else
            raise failure
          end
        end

        desc "Delete a rule", {
          success: Entities::Message,
          failure: [{ code: 404, message: "Not found", model: Entities::Message }],
          summary: "Delete a rule"
        }
        params do
          requires :id, type: String
        end
        delete "/:id" do
          extend Dry::Monads[:result, :try]

          id = params["id"].to_s

          result = Try do
            rule = Mihari::Models::Rule.find(id)
            rule.destroy
          end.to_result

          if result.success?
            status 204
            return present({ message: "ID:#{id} is deleted" }, with: Entities::Message)
          end

          failure = result.failure
          case failure
          when ActiveRecord::RecordNotFound
            error!({ message: "ID:#{id} is not found" }, 404)
          else
            raise failure
          end
        end
      end
    end
  end
end
