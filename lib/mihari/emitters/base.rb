# frozen_string_literal: true

module Mihari
  module Emitters
    class Base
      include Dry::Monads[:result, :try]

      include Mixins::Configurable
      include Mixins::Retriable

      # @return [Array<Mihari::Artifact>]
      attr_reader :artifacts

      # @return [Mihari::Services::Rule]
      attr_reader :rule

      # @return [Hash]
      attr_reader :options

      #
      # @param [Array<Mihari::Artifact>] artifacts
      # @param [Mihari::Services::RuleProxy] rule
      # @param [Hash, nil] options
      # @param [Hash] **_params
      #
      def initialize(artifacts:, rule:, options: nil, **_params)
        @artifacts = artifacts
        @rule = rule
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

      # @return [Boolean]
      def valid?
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def result
        Try[StandardError] do
          retry_on_error(
            times: retry_times,
            interval: retry_interval,
            exponential_backoff: retry_exponential_backoff
          ) do
            emit
          end
        end.to_result
      end

      def emit
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      class << self
        def inherited(child)
          super
          Mihari.emitters << child
        end
      end
    end
  end
end
