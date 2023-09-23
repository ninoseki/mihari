# frozen_string_literal: true

module Mihari
  module Services
    class AlertRunner
      include Dry::Monads[:result]

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
