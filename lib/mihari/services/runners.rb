# frozen_string_literal: true

module Mihari
  module Services
    #
    # Alert runner
    #
    class AlertRunner < Service
      #
      # @param [Mihari::Services::AlertProxy] alert
      #
      # @return [Mihari::Models::Alert]
      #
      def call(alert)
        emitter = Emitters::Database.new(rule: alert.rule)
        emitter.call alert.artifacts
      end
    end

    #
    # Rule runner
    #
    class RuleRunner < Service
      #
      # @param [String] id
      #
      def call(id)
        rule = Mihari::Rule.from_model(Mihari::Models::Rule.find(id))
        rule.call
      end
    end
  end
end
