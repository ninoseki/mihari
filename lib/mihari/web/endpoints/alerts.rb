# frozen_string_literal: true

module Mihari
  module Endpoints
    class Alerts < Grape::API
      namespace :alerts do
        desc "Search alerts", {
          is_array: true,
          success: Entities::AlertsWithPagination,
          failure: [{ code: 404, message: "Not found", model: Entities::Message }],
          summary: "Search alerts"
        }
        params do
          optional :page, type: Integer, default: 1
          optional :limit, type: Integer, default: 10

          optional :artifact, type: String
          optional :rule_id, type: String
          optional :tag, type: String

          optional :fromAt, type: DateTime
          optional :toAt, type: DateTime
        end
        get "/" do
          filter = params.to_h.to_snake_keys

          # normalize keys
          filter["artifact_data"] = filter["artifact"]
          filter["tag_name"] = filter["tag"]
          # symbolize hash keys
          filter = filter.to_h.symbolize_keys

          search_filter_with_pagination = Structs::Filters::Alert::SearchFilterWithPagination.new(**filter)
          alerts = Mihari::Alert.search(search_filter_with_pagination)
          total = Mihari::Alert.count(search_filter_with_pagination.without_pagination)

          present(
            {
              alerts: alerts,
              total: total,
              current_page: filter[:page].to_i,
              page_size: filter[:limit].to_i
            },
            with: Entities::AlertsWithPagination
          )
        end

        desc "Delete an alert", {
          success: Entities::Message,
          failure: [{ code: 404, message: "Not found", model: Entities::Message }],
          summary: "Delete an alert"
        }
        params do
          requires :id, type: Integer
        end
        delete "/:id" do
          id = params["id"].to_i

          begin
            alert = Mihari::Alert.find(id)
          rescue ActiveRecord::RecordNotFound
            error!({ message: "ID:#{id} is not found" }, 404)
          end

          alert.destroy

          status 204
          present({ message: "" }, with: Entities::Message)
        end

        desc "Create an alert", {
          success: Entities::Alert,
          summary: "Create an alert"
        }
        params do
          requires :ruleId, type: String, documentation: { param_type: "body" }
          requires :artifacts, type: Array, documentation: { type: String, is_array: true, param_type: "body" }
        end
        post "/" do
          proxy = Services::AlertProxy.new(params.to_snake_keys)
          runner = Services::AlertRunner.new(proxy)

          begin
            alert = runner.run
          rescue ActiveRecord::RecordNotFound
            error!({ message: "Rule:#{params["ruleId"]} is not found" }, 404)
          end

          status 201
          present alert, with: Entities::Alert
        end
      end
    end
  end
end
