# frozen_string_literal: true

module Mihari
  module Web
    module Endpoints
      #
      # Rule API endpoint
      #
      class Rules < Grape::API
        class RuleSearcher < Mihari::Service
          class ResultValue
            # @return [Array<Mihari::Models::Rule>]
            attr_reader :rules

            # @return [Integer]
            attr_reader :total

            # @return [Mihari::Structs::Filters::Rule::SearchFilterWithPagination]
            attr_reader :filter

            #
            # @param [Array<Mihari::Models::Rule>] rules
            # @param [Integer] total
            # @param [Mihari::Structs::Filters::Rule::SearchFilterWithPagination] filter
            #
            def initialize(rules:, total:, filter:)
              @rules = rules
              @total = total
              @filter = filter
            end
          end

          #
          # @params [Hash]
          #
          # @return [ResultValue]
          #
          def call(params)
            filter = params.to_h.to_snake_keys

            # normalize keys
            filter["tag_name"] = filter["tag"]
            # symbolize hash keys
            filter = filter.to_h.symbolize_keys

            search_filter_with_pagination = Mihari::Structs::Filters::Rule::SearchFilterWithPagination.new(**filter)
            rules = Mihari::Models::Rule.search(search_filter_with_pagination)
            total = Mihari::Models::Rule.count(search_filter_with_pagination.without_pagination)

            ResultValue.new(rules: rules, total: total, filter: filter)
          end
        end

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
            value = RuleSearcher.call(params.to_h)
            present({
              rules: value.rules,
              total: value.total,
              current_page: value.filter[:page].to_i,
              page_size: value.filter[:limit].to_i
            },
              with: Entities::RulesWithPagination)
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
            id = params[:id].to_s
            result = RuleGetter.result(params[:id].to_s)
            return present(result.value!, with: Entities::Rule) if result.success?

            failure = result.failure
            case failure
            when ActiveRecord::RecordNotFound
              error!({ message: "ID:#{id} is not found" }, 404)
            end
            raise failure
          end

          desc "Run a rule", {
            success: Entities::Message,
            summary: "Run a rule"
          }
          params do
            requires :id, type: String
          end
          get "/:id/run" do
            id = params[:id].to_s
            result = RuleRunner.result(id)
            if result.success?
              status 201
              return present({ message: "ID:#{id}} ran successfully" }, with: Entities::Message)
            end

            failure = result.failure
            case failure
            when ActiveRecord::RecordNotFound
              error!({ message: "ID:#{id} is not found" }, 404)
            end
            raise failure
          end

          desc "Create a rule", {
            success: Entities::Rule,
            summary: "Create a rule"
          }
          params do
            requires :yaml, type: String, documentation: { param_type: "body" }
          end
          post "/" do
            result = RuleCreator.result(params[:yaml])
            if result.success?
              status 201
              return present(result.value!.model, with: Entities::Rule)
            end

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
            success: Entities::Rule,
            summary: "Update a rule"
          }
          params do
            requires :id, type: String, documentation: { param_type: "body" }
            requires :yaml, type: String, documentation: { param_type: "body" }
          end
          put "/" do
            id = params[:id].to_s
            result = RuleUpdater.result(id: id, yaml: params[:yaml].to_s)
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
              error!({ message: "Rule format is invalid", details: failure.errors.to_h }, 400)
            end
            raise failure
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
            id = params[:id].to_s
            result = RuleDestroyer.result(id)
            if result.success?
              status 204
              return present({ message: "ID:#{id} is deleted" }, with: Entities::Message)
            end

            failure = result.failure
            case failure
            when ActiveRecord::RecordNotFound
              error!({ message: "ID:#{id} is not found" }, 404)
            end
            raise failure
          end
        end
      end
    end
  end
end
