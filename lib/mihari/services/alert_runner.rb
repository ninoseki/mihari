# frozen_string_literal: true

module Mihari
  module Services
    class AlertRunner
      # @return [Mihari::Services::AlertProxy]
      attr_reader :alert

      def initialize(alert)
        @alert = alert
      end

      #
      # @return [Mihari::Alert]
      #
      def run
        emitter = Mihari::Emitters::Database.new(artifacts: alert.artifacts, rule: alert.rule)
        emitter.emit
      end
    end
  end
end
