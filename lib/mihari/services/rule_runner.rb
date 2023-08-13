# frozen_string_literal: true

module Mihari
  module Services
    class RuleRunner
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
        rule.to_model.save
      end

      #
      # @return [Mihari::Alert, nil]
      #
      def run
        analyzer = rule.to_analyzer

        with_error_notification do
          analyzer.run
        end
      end
    end
  end
end
