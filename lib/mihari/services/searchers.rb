module Mihari
  module Services
    class ResultValue
      # @return [Array<Object>]
      attr_reader :results

      # @return [Integer]
      attr_reader :total

      # @return [Mihari::Structs::Filters::Search]
      attr_reader :filter

      #
      # @param [Array<Object>] results
      # @param [Integer] total
      # @param [Mihari::Structs::Filters::Search] filter
      #
      def initialize(results:, total:, filter:)
        @results = results
        @total = total
        @filter = filter
      end
    end

    class BaseSearcher < Service
      #
      # @param [Hash] params
      #
      # @return [ResultValue]
      #
      def call(params)
        filter = build_filter(params)
        ResultValue.new(
          total: klass.count_by_filter(filter),
          results: klass.search_by_filter(filter),
          filter: filter
        )
      end

      private

      #
      # @param [Hash] params
      #
      # @return [Mihari::Structs::Filters::Search]
      #
      def build_filter(params)
        normalized = params.to_h.to_snake_keys.symbolize_keys
        Structs::Filters::Search.new(**normalized)
      end
    end

    class AlertSearcher < BaseSearcher
      def klass
        Models::Alert
      end
    end

    class ArtifactSearcher < BaseSearcher
      def klass
        Models::Artifact
      end
    end

    class RuleSearcher < BaseSearcher
      def klass
        Models::Rule
      end
    end
  end
end
