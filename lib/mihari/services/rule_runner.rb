# frozen_string_literal: true

module Mihari
  module Services
    #
    # Rule runner
    #
    class RuleRunner < Service
      #
      # @params [Mihari::Rule]
      #
      # @return [Mihari::Models::Alert, nil]
      #
      def call(rule)
        rule.call
      end
    end
  end
end
