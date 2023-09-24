# frozen_string_literal: true

module Mihari
  module Services
    class AlertRunner
      include Dry::Monads[:result, :try]

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
        Try[StandardError] { run }.to_result
      end
    end
  end
end
