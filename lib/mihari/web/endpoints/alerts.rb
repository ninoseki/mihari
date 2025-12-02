# frozen_string_literal: true

module Mihari
  module Web
    module Endpoints
      #
      # Alert API endpoint
      #
      class Alerts < Grape::API
        namespace :alerts do
          desc "List/search alerts", {
            is_array: true,
            success: Entities::AlertsWithPagination,
            summary: "List/search alerts"
          }
          params do
            optional :q, type: String, default: ""
            optional :page, type: Integer, default: 1
            optional :limit, type: Integer, default: 10
          end
          get "/" do
            value = Services::AlertSearcher.call(params.to_h)
            present(
              {
                results: value.results,
                total: value.total,
                current_page: value.filter[:page].to_i,
                page_size: value.filter[:limit].to_i
              },
              with: Entities::AlertsWithPagination
            )
          end

          desc "Get an alert", {
            success: Entities::Alert,
            failure: [{code: 404, model: Entities::ErrorMessage}],
            summary: "Get an alert"
          }
          params do
            requires :id, type: Integer
          end
          get "/:id" do
            id = params[:id].to_i
            result = Services::AlertGetter.get_result(id)
            next present(result.value!, with: Entities::Alert) if result.success?

            case result.failure
            when ActiveRecord::RecordNotFound
              error!({message: "ID:#{id} not found"}, 404)
            end
            raise result.failure
          end

          desc "Delete an alert", {
            success: {code: 204},
            failure: [{code: 404, model: Entities::ErrorMessage}],
            summary: "Delete an alert"
          }
          params do
            requires :id, type: Integer
          end
          delete "/:id" do
            id = params["id"].to_i
            result = Services::AlertDestroyer.get_result(id)
            next if result.success?

            case result.failure
            when ActiveRecord::RecordNotFound
              error!({message: "ID:#{id} not found"}, 404)
            end
            raise result.failure
          end

          desc "Create an alert", {
            success: {code: 201, model: Entities::Alert},
            failure: [
              {code: 404, model: Entities::ErrorMessage}
            ],
            summary: "Create an alert"
          }
          params do
            requires :ruleId, type: String, documentation: {param_type: "body"}
            requires :artifacts, type: Array, documentation: {type: String, is_array: true, param_type: "body"}
            optional :source, type: String, documentation: {param_type: "body"}
          end
          post "/" do
            status 201

            result = Services::AlertCreator.get_result(params)
            next present(result.value!, with: Entities::Alert) if result.success?

            case result.failure
            when ActiveRecord::RecordNotFound
              error!({message: "Rule:#{params["ruleId"]} not found"}, 404)
            end
            raise result.failure
          end
        end
      end
    end
  end
end
