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
            include Mixins

            desc "validate [PATH]", "Validate a rule file"
            #
            # Validate format of a rule
            #
            # @param [String] path
            #
            def validate(path)
              rule = Dry::Monads::Try[ValidationError] { Mihari::Rule.from_yaml File.read(path) }.value!
              puts rule.data.to_yaml
            end

            desc "init [PATH]", "Initialize a new rule file"
            #
            # Initialize a new rule file
            #
            # @param [String] path
            #
            def init(path = "./rule.yml")
              warning = "#{path} exists. Do you want to overwrite it? (y/n)"
              return if Pathname(path).exist? && !(yes? warning)

              Services::RuleInitializer.call(path)

              puts "A new rule file has been initialized: #{path}."
            end

            desc "list [QUERY]", "List/search rules"
            around :with_db_connection
            method_option :page, type: :numeric, default: 1
            method_option :limit, type: :numeric, default: 10
            #
            # @param [String] q
            #
            def list(q = "")
              filter = Structs::Filters::Search.new(q: q, page: options["page"], limit: options["limit"])
              value = Services::RuleSearcher.result(filter).value!
              data = Entities::RulesWithPagination.represent(
                results: value.results,
                total: value.total,
                current_page: value.filter[:page].to_i,
                page_size: value.filter[:limit].to_i
              )
              puts JSON.pretty_generate(data.as_json)
            end

            desc "get [ID]", "Get a rule"
            around :with_db_connection
            def get(id)
              value = Services::RuleGetter.result(id).value!
              data = Entities::Rule.represent(value)
              puts JSON.pretty_generate(data.as_json)
            end

            desc "delete [ID]", "Delete a rule"
            around :with_db_connection
            #
            # @param [String] id
            #
            def delete(id)
              Services::RuleDestroyer.result(id).value!
            end
          end
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
