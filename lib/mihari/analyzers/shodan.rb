# frozen_string_literal: true

require "shodan"

module Mihari
  module Analyzers
    class Shodan < Base
      param :query
      option :title, default: proc { "Shodan search" }
      option :description, default: proc { "query = #{query}" }
      option :tags, default: proc { [] }

      option :interval, default: proc { 0 }

      def artifacts
        results = search
        return [] unless results || results.empty?

        results = results.map { |result| Structs::Shodan::Result.from_dynamic!(result) }
        results.map do |result|
          matches = result.matches || []
          matches.map { |match| build_artifact match }
        end.flatten.uniq(&:data)
      end

      private

      PAGE_SIZE = 100

      def configuration_keys
        %w[shodan_api_key]
      end

      def api
        @api ||= ::Shodan::API.new(key: Mihari.config.shodan_api_key)
      end

      #
      # Search with pagination
      #
      # @param [String] query
      # @param [Integer] page
      #
      # @return [Hash]
      #
      def search_with_page(query, page: 1)
        api.host.search(query, page: page)
      rescue ::Shodan::Error => e
        raise RetryableError, e if e.message.include?("request timed out")

        raise e
      end

      #
      # Search
      #
      # @return [Array<Hash>]
      #
      def search
        responses = []
        (1..Float::INFINITY).each do |page|
          res = search_with_page(query, page: page)

          break unless res

          responses << res
          break if res["total"].to_i <= page * PAGE_SIZE

          # sleep #{interval} seconds to avoid the rate limitation (if it is set)
          sleep interval
        rescue JSON::ParserError
          # ignore JSON::ParserError
          # ref. https://github.com/ninoseki/mihari/issues/197
          next
        end
        responses
      end

      #
      # Build an artifact from a Shodan search API response
      #
      # @param [Structs::Shodan::Match] match
      #
      # @return [Artifact]
      #
      def build_artifact(match)
        as = nil
        as = AutonomousSystem.new(asn: normalize_asn(match.asn)) unless match.asn.nil?

        geolocation = nil
        if !match.location.country_name.nil? && !match.location.country_code.nil?
          geolocation = Geolocation.new(
            country: match.location.country_name,
            country_code: match.location.country_code
          )
        end

        Artifact.new(
          data: match.ip_str,
          source: source,
          metadata: match.metadata,
          autonomous_system: as,
          geolocation: geolocation
        )
      end
    end
  end
end
