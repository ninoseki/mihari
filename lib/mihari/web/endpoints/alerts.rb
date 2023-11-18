# frozen_string_literal: true

module Mihari
  module Web
    module Endpoints
      #
      # Alert API endpoint
      #
      class Alerts < Grape::API
        class AlertSearcher < Mihari::Service
          class ResultValue
            # @return [Array<Mihari::Models::Alert>]
            attr_reader :alerts

            # @return [Integer]
            attr_reader :total

            # @return [Mihari::Structs::Filters::Alert::SearchFilterWithPagination]
            attr_reader :filter

            #
            # @param [Array<Mihari::Models::Alert>] alerts
            # @param [Integer] total
            # @param [Mihari::Structs::Filters::Alert::SearchFilterWithPagination] filter
            #
            def initialize(alerts:, total:, filter:)
              @alerts = alerts
              @total = total
              @filter = filter
            end
          end

          #
          # @param [Hash] params
          #
          # @return [ResultValue]
          #
          def call(params)
            filter = params.to_h.to_snake_keys

            # normalize keys
            filter["artifact_data"] = filter["artifact"]
            filter["tag_name"] = filter["tag"]
            # symbolize hash keys
            filter = filter.to_h.symbolize_keys

            search_filter_with_pagination = Structs::Filters::Alert::SearchFilterWithPagination.new(**filter)
            alerts = Mihari::Models::Alert.search(search_filter_with_pagination)
            total = Mihari::Models::Alert.count(search_filter_with_pagination.without_pagination)

            ResultValue.new(alerts: alerts, total: total, filter: filter)
          end
        end

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
          desc "Search alerts", {
            is_array: true,
            success: Entities::AlertsWithPagination,
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
            value = AlertSearcher.call(params.to_h)
            present(
              {
                alerts: value.alerts,
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
