# frozen_string_literal: true

module Mihari
  module Commands
    #
    # Rule sub-commands
    #
    module Rule
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
                filter = Structs::Filters::Search.new(q:, page:, limit:)
                Services::RuleSearcher.call filter
              end
            end

            desc "validate PATH", "Validate rule(s)"
            #
            # Validate rule(s)
            #
            # @param [Array<String>] paths
            #
            def validate(*paths)
              # @type [Array<Mihari::ValidationError>]
              errors = paths.flat_map { |path| Dir.glob(path) }.map do |path|
                Dry::Monads::Try[ValidationError] { Mihari::Rule.from_file(path) }
              end.filter_map do |result|
                result.exception if result.error?
              end
              return if errors.empty?

              errors.each do |error|
                data = Entities::ErrorMessage.represent(message: error.message, detail: error.detail)
                warn JSON.pretty_generate(data.as_json)
              end

              exit 1
            end

            desc "format PATH", "format a rule"
            #
            # Format a rule file
            #
            # @param [String] path
            #
            def format(path)
              rule = Dry::Monads::Try[ValidationError] { Mihari::Rule.from_file(path) }.value!
              puts rule.data.to_yaml
            end

            desc "init PATH", "Initialize a new rule"
            #
            # Initialize a new rule file
            #
            # @param [String] path
            #
            def init(path = "./rule.yml")
              warning = "Do you want to overwrite it? (y/n)"
              return if Pathname(path).exist? && !(yes? warning)

              Services::RuleInitializer.call path
            end

            desc "list QUERY", "List/search rules"
            around :with_db_connection
            method_option :page, type: :numeric, default: 1
            method_option :limit, type: :numeric, default: 10
            #
            # @param [String] q
            #
            def list(q = "")
              value = _search(q, page: options["page"], limit: options["limit"])
              data = Entities::RulesWithPagination.represent(
                results: value.results,
                total: value.total,
                current_page: value.filter[:page].to_i,
                page_size: value.filter[:limit].to_i
              )
              puts JSON.pretty_generate(data.as_json)
            end

            desc "list-transform QUERY", "List/search rules with transformation"
            around :with_db_connection
            method_option :template, type: :string, required: true, aliases: "-t",
              desc: "Jbuilder template stringor a path to a template"
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

            desc "get ID", "Get a rule"
            around :with_db_connection
            def get(id)
              value = Services::RuleGetter.get_result(id).value!
              data = Entities::Rule.represent(value)
              puts JSON.pretty_generate(data.as_json)
            end

            desc "delete ID", "Delete a rule"
            around :with_db_connection
            #
            # @param [String] id
            #
            def delete(id)
              Services::RuleDestroyer.call id
            end
          end
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
