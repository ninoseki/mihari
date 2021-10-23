# frozen_string_literal: true

require "greynoise"

module Mihari
  module Analyzers
    class GreyNoise < Base
      param :query
      option :title, default: proc { "GreyNoise search" }
      option :description, default: proc { "query = #{query}" }
      option :tags, default: proc { [] }

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

      def api
        @api ||= ::GreyNoise::API.new(key: Mihari.config.greynoise_api_key)
      end

      #
      # Search
      #
      # @return [Hash]
      #
      def search
        api.experimental.gnql(query, size: PAGE_SIZE)
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
          autonomous_system: as,
          geolocation: geolocation
        )
      end
    end
  end
end
