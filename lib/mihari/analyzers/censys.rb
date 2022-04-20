# frozen_string_literal: true

require "censysx"

module Mihari
  module Analyzers
    class Censys < Base
      param :query

      option :interval, default: proc { 0 }

      # @return [String, nil]
      attr_reader :id

      # @return [String, nil]
      attr_reader :secret

      def initialize(*args, **kwargs)
        super(*args, **kwargs)

        @id = kwargs[:id] || Mihari.config.censys_id
        @secret = kwargs[:secret] || Mihari.config.censys_secret
      end

      def artifacts
        search
      end

      def configured?
        configuration_keys.all? { |key| Mihari.config.send(key) } || (id? && secret?)
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

          # sleep #{interval} seconds to avoid the rate limitation (if it is set)
          sleep interval
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

        ports = hit.services.map(&:port).map do |port|
          Port.new(port: port)
        end

        Artifact.new(
          data: hit.ip,
          source: source,
          metadata: hit.metadata,
          autonomous_system: as,
          geolocation: geolocation,
          ports: ports
        )
      end

      def configuration_keys
        %w[censys_id censys_secret]
      end

      def api
        @api ||= ::Censys::API.new(id, secret)
      end

      def id?
        !id.nil?
      end

      def secret?
        !secret.nil?
      end
    end
  end
end
