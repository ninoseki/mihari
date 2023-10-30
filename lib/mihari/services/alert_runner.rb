# frozen_string_literal: true

module Mihari
  module Services
    #
    # Alert runner
    #
    class AlertRunner < Service
      # @return [Mihari::Services::AlertProxy]
      attr_reader :alert

      def initialize(alert)
        super()

        @alert = alert
      end

      #
      # @return [Mihari::Models::Alert]
      #
      def call
        emitter = Emitters::Database.new(rule: alert.rule)
        emitter.call alert.artifacts
      end
    end
  end
end
