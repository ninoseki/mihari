# frozen_string_literal: true

module Mihari
  module Emitters
    #
    # Base class for emitters
    #
    class Base < Actor
      # @return [Mihari::Rule]
      attr_reader :rule

      #
      # @param [Mihari::Rule] rule
      # @param [Hash, nil] options
      #
      def initialize(rule:, options: nil)
        super(options: options)

        @rule = rule
      end

      #
      # @param [Array<Mihari::Models::Artifact>] artifacts
      #
      def call(artifacts)
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      #
      # @return [Dry::Monads::Result::Success<Object>, Dry::Monads::Result::Failure]
      #
      def result(artifacts)
        result = Try[StandardError] do
          retry_on_error(
            times: retry_times,
            interval: retry_interval,
            exponential_backoff: retry_exponential_backoff
          ) { call(artifacts) }
        end.to_result

        Mihari.logger.warn("Emitter:#{self.class.key} failed - #{result.failure}") if result.failure?

        result
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
