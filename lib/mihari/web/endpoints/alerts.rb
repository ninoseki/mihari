# frozen_string_literal: true

module Mihari
  module Web
    module Endpoints
      #
      # Alert API endpoint
      #
      class Alerts < Grape::API
        class AlertCreator < Service
          #
          # @param [Hash] params
          #
          # @return [Mihari::Models::Alert]
          #
          def call(params)
            proxy = Services::AlertProxy.new(**params.to_snake_keys)
            Services::AlertRunner.call proxy
          end
        end

        class AlertDestroyer < Service
          #
          # @param [String] id
          #
          def call(id)
            Mihari::Models::Alert.find(id).destroy
          end
        end

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
                alerts: value.results,
                total: value.total,
                current_page: value.filter[:page].to_i,
                page_size: value.filter[:limit].to_i
              },
              with: Entities::AlertsWithPagination
            )
          end

          desc "Delete an alert", {
            success: { code: 204, model: Entities::Message },
            failure: [{ code: 404, model: Entities::Message }],
            summary: "Delete an alert"
          }
          params do
            requires :id, type: Integer
          end
          delete "/:id" do
            status 204

            id = params["id"].to_i
            result = AlertDestroyer.result(id)
            return present({ message: "" }, with: Entities::Message) if result.success?

            case result.failure
            when ActiveRecord::RecordNotFound
              error!({ message: "ID:#{id} is not found" }, 404)
            end
            raise result.failure
          end

          desc "Create an alert", {
            success: { code: 201, model: Entities::Alert },
            failure: [{ code: 404, model: Entities::Message }],
            summary: "Create an alert"
          }
          params do
            requires :ruleId, type: String, documentation: { param_type: "body" }
            requires :artifacts, type: Array, documentation: { type: String, is_array: true, param_type: "body" }
          end
          post "/" do
            status 201

            result = AlertCreator.result(params)
            return present(result.value!, with: Entities::Alert) if result.success?

            case result.failure
            when ActiveRecord::RecordNotFound
              error!({ message: "Rule:#{params["ruleId"]} is not found" }, 404)
            end
            raise result.failure
          end
        end
      end
    end
  end
end
