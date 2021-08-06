# frozen_string_literal: true

module Mihari
  module Commands
    module Search
      include Mixins::Rule

      def self.included(thor)
        thor.class_eval do
          desc "search [RULE]", "Search by a rule"
          def search_by_rule(rule)
            # convert str(YAML) to hash or str(path/YAML file) to hash
            rule = load_rule(rule)

            # validate rule schema
            rule = validate_rule(rule)

            analyzer = build_rule_analyzer(
              title: rule[:title],
              description: rule[:description],
              queries: rule[:queries],
              tags: rule[:tags],
              allowed_data_types: rule[:allowed_data_types],
              disallowed_data_values: rule[:disallowed_data_values],
              source: rule[:source],
              id: rule[:id]
            )

            ignore_old_artifacts = rule[:ignore_old_artifacts]
            ignore_threshold = rule[:ignore_threshold]

            with_error_handling do
              run_rule_analyzer analyzer, ignore_old_artifacts: ignore_old_artifacts, ignore_threshold: ignore_threshold
            end
          end
        end
      end

      private

      #
      # Build a rule analyzer
      #
      # @param [String] title
      # @param [String] description
      # @param [Array<Hash>] queries
      # @param [Array<String>, nil] tags
      # @param [Array<String>, nil] allowed_data_types
      # @param [Array<String>, nil] disallowed_data_values
      # @param [String, nil] source
      #
      # @return [Mihari::Analyzers::Rule]
      #
      def build_rule_analyzer(title:, description:, queries:, tags: nil, allowed_data_types: nil, disallowed_data_values: nil, source: nil, id: nil)
        tags = [] if tags.nil?
        allowed_data_types = ALLOWED_DATA_TYPES if allowed_data_types.nil?
        disallowed_data_values = [] if disallowed_data_values.nil?

        Analyzers::Rule.new(
          title: title,
          description: description,
          tags: tags,
          queries: queries,
          allowed_data_types: allowed_data_types,
          disallowed_data_values: disallowed_data_values,
          source: source,
          id: id
        )
      end

      #
      # Run rule analyzer
      #
      # @param [Mihari::Analyzer::Rule] analyzer
      #
      # @return [nil]
      #
      def run_rule_analyzer(analyzer, ignore_old_artifacts: false, ignore_threshold: 0)
        load_configuration

        analyzer.ignore_old_artifacts = ignore_old_artifacts
        analyzer.ignore_threshold = ignore_threshold

        analyzer.run
      end
    end
  end
end
