# frozen_string_literal: true

module Mihari
  module Commands
    #
    # Alert sub-commands
    #
    module Alert
      class << self
        # rubocop:disable Metrics/AbcSize
        def included(thor)
          thor.class_eval do
            include Concerns::DatabaseConnectable

            no_commands do
              #
              # @param [String] q
              # @param [Integer] page
              # @param [Integer] limit
              #
              # @return [Mihari::Services::ResultValue]
              #
              def _search(q, page: 1, limit: 10)
                filter = Structs::Filters::Search.new(q: q, page: page, limit: limit)
                Services::AlertSearcher.result(filter).value!
              end
            end

            desc "create [PATH]", "Create an alert"
            around :with_db_connection
            #
            # @param [String] path
            #
            def create(path)
              # @type [Mihari::Models::Alert]
              alert = Dry::Monads::Try[StandardError] do
                raise ArgumentError, "#{path} not found" unless Pathname(path).exist?

                params = YAML.safe_load(
                  ERB.new(File.read(path)).result,
                  permitted_classes: [Date, Symbol]
                )
                Services::AlertCreator.call params
              end.value!
              data = Entities::Alert.represent(alert)
              puts JSON.pretty_generate(data.as_json)
            end

            desc "list [QUERY]", "List/search alerts"
            around :with_db_connection
            method_option :page, type: :numeric, default: 1
            method_option :limit, type: :numeric, default: 10
            #
            # @param [String] q
            #
            def list(q = "")
              value = _search(q, page: options["page"], limit: options["limit"])
              data = Entities::AlertsWithPagination.represent(
                results: value.results,
                total: value.total,
                current_page: value.filter[:page].to_i,
                page_size: value.filter[:limit].to_i
              )
              puts JSON.pretty_generate(data.as_json)
            end

            desc "list-transform QUERY", "List/search alerts with transformation"
            around :with_db_connection
            method_option :template, type: :string, required: true, aliases: "-t",
              description: "Jbuilder template itself or a path to a template file"
            method_option :page, type: :numeric, default: 1
            method_option :limit, type: :numeric, default: 10
            #
            # @param [String] q
            #
            def list_transform(q = "")
              value = _search(q, page: options["page"], limit: options["limit"])
              puts Services::JbuilderRenderer.call(
                options["template"],
                {
                  results: value.results,
                  total: value.total,
                  current_page: value.filter[:page].to_i,
                  page_size: value.filter[:limit].to_i
                }
              )
            end

            desc "get [ID]", "Get an alert"
            around :with_db_connection
            #
            # @param [Integer] id
            #
            def get(id)
              value = Services::AlertGetter.result(id).value!
              data = Entities::Alert.represent(value)
              puts JSON.pretty_generate(data.as_json)
            end

            desc "delete [ID]", "Delete an alert"
            around :with_db_connection
            #
            # @param [Integer] id
            #
            def delete(id)
              Services::AlertDestroyer.result(id).value!
            end
          end
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
