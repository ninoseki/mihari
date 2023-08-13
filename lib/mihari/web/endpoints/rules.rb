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
          rule_ids = Mihari::Rule.distinct.pluck(:id)
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
          rules = Mihari::Rule.search(search_filter_with_pagenation)
          total = Mihari::Rule.count(search_filter_with_pagenation.without_pagination)

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
          id = params["id"].to_s

          begin
            rule = Mihari::Rule.find(id)
          rescue ActiveRecord::RecordNotFound
            error!({ message: "ID:#{id} is not found" }, 404)
          end

          present rule, with: Entities::Rule
        end

        desc "Run a rule", {
          success: Entities::Message,
          summary: "Run a rule"
        }
        params do
          requires :id, type: String
        end
        get "/:id/run" do
          id = params["id"].to_s

          begin
            rule = Mihari::Services::RuleProxy.from_model(Mihari::Rule.find(id))
          rescue ActiveRecord::RecordNotFound
            error!({ message: "ID:#{id} is not found" }, 404)
          end

          analyzer = rule.analyzer
          analyzer.run

          status 201
          present({ message: "ID:#{id} is ran successfully" }, with: Entities::Message)
        end

        desc "Create a rule", {
          success: Entities::Rule,
          summary: "Create a rule"
        }
        params do
          requires :yaml, type: String, documentation: { param_type: "body" }
        end
        post "/" do
          yaml = params[:yaml]

          begin
            rule = Services::RuleProxy.from_yaml(yaml)
          rescue YAMLSyntaxError => e
            error!({ message: e.message }, 400)
          end

          # check ID duplication
          begin
            Mihari::Rule.find(rule.id)
            error!({ message: "ID:#{rule.id} is already registered" }, 400)
          rescue ActiveRecord::RecordNotFound
            # do nothing
          end

          begin
            rule.validate!
          rescue RuleValidationError
            error!({ message: "Data format is invalid", details: rule.errors.to_h }, 400) if rule.errors?

            # when NoMethodError occurs
            error!({ message: "Data format is invalid" }, 400)
          end

          begin
            rule.model.save
          rescue ActiveRecord::RecordNotUnique
            error!({ message: "ID:#{rule.id} is already registered" }, 400)
          end

          status 201
          present rule.model, with: Entities::Rule
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
          id = params[:id]
          yaml = params[:yaml]

          begin
            Mihari::Rule.find(id)
          rescue ActiveRecord::RecordNotFound
            error!({ message: "ID:#{id} is not found" }, 404)
          end

          begin
            rule = Services::RuleProxy.from_yaml(yaml)
          rescue YAMLSyntaxError => e
            error!({ message: e.message }, 400)
          end

          begin
            rule.validate!
          rescue RuleValidationError
            error!({ message: "Data format is invalid", details: rule.errors.to_h }, 400) if rule.errors?

            # when NoMethodError occurs
            error!({ message: "Data format is invalid" }, 400)
          end

          begin
            rule.model.save
          rescue ActiveRecord::RecordNotUnique
            error!({ message: "ID:#{id} is already registered" }, 400)
          end

          status 201
          present rule.model, with: Entities::Rule
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
          id = params["id"].to_s

          begin
            rule = Mihari::Rule.find(id)
          rescue ActiveRecord::RecordNotFound
            error!({ message: "ID:#{id} is not found" }, 404)
          end

          rule.destroy

          status 204
          present({ message: "ID:#{id} is deleted" }, with: Entities::Message)
        end
      end
    end
  end
end
