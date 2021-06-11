# frozen_string_literal: true

require "yaml"
require "json"
require "pathname"

module Mihari
  module Commands
    module Search
      include Mixins::Utils

      def self.included(thor)
        thor.class_eval do
          desc "search [RULE]", "Search by a rule"
          def search_by_rule(rule)
            # convert str(YAML) to hash or str(path/YAML file) to hash
            rule = load_rule(rule)

            # validate rule schema
            validate_rule rule

            analyzer = build_rule_analyzer(**rule)

            ignore_old_artifacts = options["ignore_old_artifacts"] || false
            ignore_threshold = options["ignore_threshold"] || 0

            with_error_handling do
              run_rule_analyzer analyzer, ignore_old_artifacts: ignore_old_artifacts, ignore_threshold: ignore_threshold
            end
          end
        end
      end

      private

      #
      # Load rule into hash
      #
      # @param [String] rule path to YAML file or YAML string
      #
      # @return [Hash]
      #
      def load_rule(rule)
        return YAML.safe_load(File.read(rule), symbolize_names: true) if Pathname(rule).exist?

        YAML.safe_load(rule, symbolize_names: true)
      end

      #
      # Validate rule schema
      #
      # @param [Hash] rule
      #
      def validate_rule(rule)
        error_message = "Failed to parse the input as a rule!"
        contract = Schemas::RuleContract.new
        begin
          result = contract.call(rule)
          unless result.errors.empty?
            messages = result.errors.messages.map do |message|
              path = message.path.map(&:to_s).join
              "#{path} #{message.text}"
            end
            puts error_message.colorize(:red)
            raise ArgumentError, messages.join("\n")
          end
        rescue NoMethodError
          puts error_message.colorize(:red)
          raise ArgumentError, "Failed to parse YAML file"
        end
      end

      #
      # Build a rule
      #
      # @param [String] title
      # @param [String] description
      # @param [Array<Hash>] queries
      # @param [Array<String>, nil] tags
      # @param [Array<String>, nil] allowed_data_types
      # @param [String, nil] source
      #
      # @return [Mihari::Analyzers::Rule]
      #
      def build_rule_analyzer(title:, description:, queries:, tags: nil, allowed_data_types: nil, source: nil)
        tags = [] if tags.nil?
        allowed_data_types = ALLOWED_DATA_TYPES if allowed_data_types.nil?

        Analyzers::Rule.new(
          title: title,
          description: description,
          tags: tags,
          queries: queries,
          allowed_data_types: allowed_data_types,
          source: source
        )
      end

      #
      # Run rule analyzer
      #
      # @param [Mihari::Analyzer::Rule] analyzer
      # @param [Boolean] ignore_old_artifacts
      # @param [Integer] ignore_threshold
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
