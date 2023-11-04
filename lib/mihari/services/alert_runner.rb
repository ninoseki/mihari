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
  end
end
