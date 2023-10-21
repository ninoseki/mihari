# frozen_string_literal: true

module Mihari
  module Enrichers
    class Base
      include Mixins::Configurable
      include Mixins::Retriable

      include Dry::Monads[:result, :try]

      # @return [Hash]
      attr_reader :options

      def initialize(options: nil)
        @options = options || {}
      end

      #
      # @return [Integer]
      #
      def retry_interval
        options[:retry_interval] || Mihari.config.retry_interval
      end

      #
      # @return [Boolean]
      #
      def retry_exponential_backoff
        options[:retry_exponential_backoff] || Mihari.config.retry_exponential_backoff
      end

      #
      # @return [Integer]
      #
      def retry_times
        options[:retry_times] || Mihari.config.retry_times
      end

      #
      # @return [Integer, nil]
      #
      def timeout
        options[:timeout]
      end

      def query_result(value)
        Try[StandardError] do
          retry_on_error(
            times: retry_times,
            interval: retry_interval,
            exponential_backoff: retry_exponential_backoff
          ) { query value }
        end.to_result
      end

      #
      # @param [String] value
      #
      def query(value)
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      class << self
        def inherited(child)
          super
          Mihari.enrichers << child
        end
      end
    end
  end
end
