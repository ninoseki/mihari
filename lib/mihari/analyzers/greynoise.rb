# frozen_string_literal: true

module Mihari
  module Analyzers
    class GreyNoise < Base
      param :query

      # @return [String, nil]
      attr_reader :api_key

      def initialize(*args, **kwargs)
        super(*args, **kwargs)

        @api_key = kwargs[:api_key] || Mihari.config.greynoise_api_key
      end

      def artifacts
        res = Structs::GreyNoise::Response.from_dynamic!(search)
        res.data.map do |datum|
          build_artifact datum
        end
      end

      private

      PAGE_SIZE = 10_000

      def configuration_keys
        %w[greynoise_api_key]
      end

      def client
        @client ||= Clients::GreyNoise.new(api_key: api_key)
      end

      #
      # Search
      #
      # @return [Hash]
      #
      def search
        client.gnql_search(query, size: PAGE_SIZE)
      end

      #
      # Build an artifact from a GreyNoise search API response
      #
      # @param [Structs::GreyNoise::Datum] datum
      #
      # @return [Artifact]
      #
      def build_artifact(datum)
        as = AutonomousSystem.new(asn: normalize_asn(datum.metadata.asn))

        geolocation = Geolocation.new(
          country: datum.metadata.country,
          country_code: datum.metadata.country_code
        )

        Artifact.new(
          data: datum.ip,
          source: source,
          metadata: datum.metadata_,
          autonomous_system: as,
          geolocation: geolocation
        )
      end
    end
  end
end
