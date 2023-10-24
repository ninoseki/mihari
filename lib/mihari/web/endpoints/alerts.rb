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
          alerts = Mihari::Models::Alert.search(search_filter_with_pagination)
          total = Mihari::Models::Alert.count(search_filter_with_pagination.without_pagination)

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
          extend Dry::Monads[:result, :try]

          id = params["id"].to_i

          result = Try do
            alert = Mihari::Models::Alert.find(id)
            alert.destroy
          end.to_result

          if result.success?
            status 204
            return present({ message: "" }, with: Entities::Message)
          end

          failure = result.failure
          case failure
          when ActiveRecord::RecordNotFound
            error!({ message: "ID:#{id} is not found" }, 404)
          else
            raise failure
          end
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
          extend Dry::Monads[:result, :try]

          result = Try do
            proxy = Services::AlertProxy.new(params.to_snake_keys)
            runner = Services::AlertRunner.new(proxy)
            runner.run
          end.to_result

          if result.success?
            status 201
            return present(result.value!, with: Entities::Alert)
          end

          failure = result.failure
          case failure
          when ActiveRecord::RecordNotFound
            error!({ message: "Rule:#{params["ruleId"]} is not found" }, 404)
          else
            raise failure
          end
        end
      end
    end
  end
end
