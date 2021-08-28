# frozen_string_literal: true

require "censysx"

module Mihari
  module Analyzers
    class Censys < Base
      param :query
      option :title, default: proc { "Censys search" }
      option :description, default: proc { "query = #{query}" }
      option :tags, default: proc { [] }

      def artifacts
        search
      end

      private

      #
      # Search
      #
      # @return [Array<String>]
      #
      def search
        artifacts = []

        cursor = nil
        loop do
          response = api.search(query, cursor: cursor)
          response = Structs::Censys::Response.from_dynamic!(response)

          artifacts << response_to_artifacts(response)

          cursor = response.result.links.next
          break if cursor == ""
        end

        artifacts.flatten.uniq(&:data)
      end

      #
      # Extract IPv4s from Censys search API response
      #
      # @param [Structs::Censys::Response] response
      #
      # @return [Array<String>]
      #
      def response_to_artifacts(response)
        response.result.hits.map { |hit| build_artifact(hit) }
      end

      #
      # Build an artifact from a Shodan search API response
      #
      # @param [Structs::Censys::Hit] hit
      #
      # @return [Artifact]
      #
      def build_artifact(hit)
        as = AutonomousSystem.new(asn: normalize_asn(hit.autonomous_system.asn))

        # sometimes Censys overlooks country
        # then set geolocation as nil
        geolocation = nil
        unless hit.location.country.nil?
          geolocation = Geolocation.new(
            country: hit.location.country,
            country_code: hit.location.country_code
          )
        end

        Artifact.new(
          data: hit.ip,
          source: source,
          autonomous_system: as,
          geolocation: geolocation
        )
      end

      def configuration_keys
        %w[censys_id censys_secret]
      end

      def api
        @api ||= ::Censys::API.new(Mihari.config.censys_id, Mihari.config.censys_secret)
      end
    end
  end
end
