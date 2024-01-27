# frozen_string_literal: true

module Mihari
  module Enrichers
    #
    # MMDB enricher
    #
    class MMDB < Base
      #
      # @param [Mihari::Models::Artifact] artifact
      #
      def call(artifact)
        res = client.query(artifact.data)

        artifact.tap do |tapped|
          tapped.autonomous_system ||= Models::AutonomousSystem.new(number: res.asn) if res.asn
          if res.country_code
            tapped.geolocation ||= Models::Geolocation.new(
              country: NormalizeCountry(res.country_code, to: :short),
              country_code: res.country_code
            )
          end
        end
      end

      private

      #
      # @param [Mihari::Models::Artifact] artifact
      #
      # @return [Boolean]
      #
      def callable_relationships?(artifact)
        artifact.geolocation.nil? || artifact.autonomous_system.nil?
      end

      def supported_data_types
        %w[ip]
      end

      def client
        @client ||= Clients::MMDB.new(timeout:)
      end
    end
  end
end
