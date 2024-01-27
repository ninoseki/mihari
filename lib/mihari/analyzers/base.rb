# frozen_string_literal: true

module Mihari
  module Analyzers
    #
    # Base class for analyzers
    #
    class Base < Actor
      # @return [String]
      attr_reader :query

      #
      # @param [String] query
      # @param [Hash, nil] options
      #
      def initialize(query, options: nil)
        super(options:)

        @query = query
      end

      #
      # @return [Integer]
      #
      def pagination_interval
        options[:pagination_interval] || Mihari.config.pagination_interval
      end

      #
      # @return [Integer]
      #
      def pagination_limit
        options[:pagination_limit] || Mihari.config.pagination_limit
      end

      #
      # @return [Boolean]
      #
      def ignore_error?
        options[:ignore_error] || Mihari.config.ignore_error
      end

      #
      # @return [Boolean]
      #
      def parallel?
        options[:parallel] || Mihari.config.parallel
      end

      # @return [Array<String>, Array<Mihari::Models::Artifact>]
      def artifacts
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      #
      # Normalize artifacts
      # - Convert data (string) into an artifact
      # - Reject an invalid artifact
      #
      # @return [Array<Mihari::Models::Artifact>]
      #
      def normalized_artifacts
        artifacts.compact.sort.map do |artifact|
          # No need to set data_type manually
          # It is set automatically in #initialize
          (artifact.is_a?(Models::Artifact) ? artifact : Models::Artifact.new(data: artifact)).tap do |normalized|
            normalized.source = self.class.key
            normalized.query = query
          end
        end.select(&:valid?).uniq(&:data)
      end

      #
      # @return [Array<Mihari::Models::Artifact>]
      #
      def call
        normalized_artifacts
      end

      def result(...)
        result = Try[StandardError] do
          retry_on_error(
            times: retry_times,
            interval: retry_interval,
            exponential_backoff: retry_exponential_backoff
          ) do
            call(...)
          end
        end.to_result

        return result if result.success?

        # Wrap failure with AnalyzerError to explicitly name a failed analyzer
        error = AnalyzerError.new(result.failure.message, self.class.key, cause: result.failure)
        return Failure(error) unless ignore_error?

        # Return Success if ignore_error? is true with logging
        Mihari.logger.warn("Analyzer:#{self.class.key} with #{truncated_query} failed - #{result.failure}")
        Success([])
      end

      #
      # Truncate query for logging
      #
      # @return [String]
      #
      def truncated_query
        query.truncate(32)
      end

      class << self
        #
        # Initialize an analyzer by query params
        #
        # @param [Hash] params
        #
        # @return [Mihari::Analyzers::Base]
        #
        def from_params(params)
          query = params.delete(:query)
          new(query, **params)
        end

        def inherited(child)
          super
          Mihari.analyzers << child
        end
      end
    end
  end
end
