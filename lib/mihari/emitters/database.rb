# frozen_string_literal: true

module Mihari
  module Emitters
    #
    # Database emitter
    #
    class Database < Base
      #
      # Create an alert
      #
      # @param [Array<Mihari::Models::Artifact>] artifacts
      #
      # @return [Mihari::Models::Alert, nil]
      #
      def call(artifacts)
        return if artifacts.empty?

        alert = Models::Alert.new(artifacts:, rule_id: rule.id)
        alert.save
        alert
      end

      def target
        Mihari.config.database_url.host || Mihari.config.database_url.to_s
      end
    end
  end
end
