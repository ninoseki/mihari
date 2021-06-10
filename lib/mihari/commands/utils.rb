require "cymbal"

module Mihari
  module Commands
    module Utils
      private

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

        queries = symbolize_queries(queries)

        Analyzers::Rule.new(
          title: title,
          description: description,
          tags: tags,
          queries: queries,
          allowed_data_types: allowed_data_types,
          source: source
        )
      end

      def run_rule_analyzer(analyzer, ignore_old_artifacts: false, ignore_threshold: 0)
        load_configuration

        analyzer.ignore_old_artifacts = ignore_old_artifacts
        analyzer.ignore_threshold = ignore_threshold

        analyzer.run
      end

      def symbolize_queries(queries)
        queries.map do |query|
          Cymbal.symbolize query
        end
      end
    end
  end
end
