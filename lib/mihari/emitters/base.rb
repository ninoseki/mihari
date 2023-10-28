# frozen_string_literal: true

module Mihari
  module Emitters
    class Base < Actor
      # @return [Array<Mihari::Models::Artifact>]
      attr_reader :artifacts

      # @return [Mihari::Rule]
      attr_reader :rule

      #
      # @param [Array<Mihari::Models::Artifact>] artifacts
      # @param [Mihari::Rule] rule
      # @param [Hash, nil] options
      # @param [Hash] **_params
      #
      def initialize(artifacts:, rule:, options: nil, **_params)
        super(options: options)

        @artifacts = artifacts
        @rule = rule
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
          ) { emit }
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
