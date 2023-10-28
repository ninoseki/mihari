# frozen_string_literal: true

module Mihari
  module Emitters
    class Base < Actor
      # @return [Mihari::Rule]
      attr_reader :rule

      #
      # @param [Mihari::Rule] rule
      # @param [Hash, nil] options
      # @param [Hash] **_params
      #
      def initialize(rule:, options: nil, **_params)
        super(options: options)

        @rule = rule
      end

      #
      # @param [Array<Mihari::Models::Artifact>] artifacts
      #
      def emit_result(artifacts)
        Try[StandardError] do
          retry_on_error(
            times: retry_times,
            interval: retry_interval,
            exponential_backoff: retry_exponential_backoff
          ) { emit artifacts }
        end.to_result
      end

      #
      # @param [Array<Mihari::Models::Artifact>] artifacts
      #
      def emit(artifacts)
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
