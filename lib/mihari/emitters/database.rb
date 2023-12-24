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

        alert = Models::Alert.new(artifacts: artifacts, rule_id: rule.id)
        alert.save
        alert
      end

      class << self
        def configuration_keys
          %w[database_url]
        end
      end
    end
  end
end
