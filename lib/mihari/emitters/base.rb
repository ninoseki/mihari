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

      #
      # @param [Array<Mihari::Artifact>] artifacts
      # @param [Mihari::Services::RuleProxy] rule
      # @param [Hash] **_options
      #
      def initialize(artifacts:, rule:, **_options)
        @artifacts = artifacts
        @rule = rule
      end

      class << self
        def inherited(child)
          super
          Mihari.emitters << child
        end
      end

      # @return [Boolean]
      def valid?
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def run
        retry_on_error { emit }
      end

      def result
        Try[StandardError] { run }.to_result
      end

      def emit
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end
    end
  end
end
