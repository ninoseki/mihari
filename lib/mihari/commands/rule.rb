# frozen_string_literal: true

require "pathname"

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
            include Dry::Monads[:try, :result]

            desc "validate [PATH]", "Validate a rule file"
            #
            # Validate format of a rule
            #
            # @param [String] path
            #
            def validate(path)
              res = Dry::Monads::Try[ValidationError] { Mihari::Rule.from_yaml File.read(path) }
              rule = res.value!
              puts rule.data.to_yaml
            end

            desc "init [PATH]", "Initialize a new rule file"
            #
            # Initialize a new rule file
            #
            # @param [String] path
            #
            #
            def init(path = "./rule.yml")
              warning = "#{path} exists. Do you want to overwrite it? (y/n)"
              return if Pathname(path).exist? && !(yes? warning)

              initialize_rule path

              puts "A new rule file has been initialized: #{path}."
            end

            desc "list", "List/search rules"
            around :with_db_connection
            method_option :page, type: :numeric, default: 1
            method_option :limit, type: :numeric, default: 10
            #
            # @param [String] q
            #
            def list(q = "")
              filter = Structs::Filters::Search.new(q: q, page: options["page"], limit: options["limit"])
              result = Services::RuleSearcher.result(filter)
              value = result.value!
              data = Entities::RulesWithPagination.represent(
                rules: value.results,
                total: value.total,
                current_page: value.filter[:page].to_i,
                page_size: value.filter[:limit].to_i
              )
              puts JSON.pretty_generate(data.as_json)
            end

            no_commands do
              #
              # Create a new rule
              #
              # @param [String] path
              # @param [Dry::Files] files
              #
              # @return [nil]
              #
              def initialize_rule(path, files = Dry::Files.new)
                rule = Mihari::Rule.new(
                  id: SecureRandom.uuid,
                  title: "Title goes here",
                  description: "Description goes here",
                  created_on: Date.today,
                  queries: []
                )
                files.write(path, rule.yaml)
              end
            end
          end
        end
        # rubocop:enable Metrics/AbcSize
      end
    end
  end
end
