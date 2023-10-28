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
      # @return [Mihari::Models::Alert]
      #
      def run
        emitter = Emitters::Database.new(rule: alert.rule)
        emitter.emit alert.artifacts
      end

      #
      # @return [Dry::Monads::Result::Success<Mihari::Models::Alert, nil>, Dry::Monads::Result::Failure]
      #
      def result
        Try[StandardError] { run }.to_result
      end
    end
  end
end
