# frozen_string_literal: true

module Mihari
  module Services
    #
    # Rule runner
    #
    class RuleRunner < Service
      include Dry::Monads[:result, :try]

      # @return [Mihari::Rule]
      attr_reader :rule

      def initialize(rule)
        super()

        @rule = rule
      end

      #
      # @return [Boolean]
      #
      def diff?
        model = Mihari::Models::Rule.find(rule.id)
        model.data != rule.data.deep_stringify_keys
      rescue ActiveRecord::RecordNotFound
        false
      end

      def update_or_create
        rule.model.save
      end

      #
      # @return [Mihari::Models::Alert, nil]
      #
      def call
        rule.call
      end
    end
  end
end
