# frozen_string_literal: true

module Mihari
  module Services
    class RuleRunner
      include Dry::Monads[:result]

      include Mixins::ErrorNotification

      # @return [Mihari::Services::RuleProxy]
      attr_reader :rule

      # @return [Boolean]
      attr_reader :force_overwrite

      def initialize(rule, force_overwrite:)
        @rule = rule
        @force_overwrite = force_overwrite
      end

      def force_overwrite?
        force_overwrite
      end

      #
      # @return [Boolean]
      #
      def diff?
        model = Mihari::Rule.find(rule.id)
        model.data != rule.data.deep_stringify_keys
      rescue ActiveRecord::RecordNotFound
        false
      end

      def update_or_create
        rule.model.save
      end

      #
      # @return [Mihari::Alert, nil]
      #
      def run
        rule.analyzer.run
      end

      #
      # @return [Dry::Monads::Result::Success<Mihari::Alert, nil>, Dry::Monads::Result::Failure]
      #
      def result
        Success run
      rescue StandardError => e
        Failure e
      end
    end
  end
end
