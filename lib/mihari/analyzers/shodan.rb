# frozen_string_literal: true

require "shodan"

module Mihari
  module Analyzers
    class Shodan < Base
      param :query

      option :interval, default: proc { 0 }

      # @return [String, nil]
      attr_reader :api_key

      def initialize(*args, **kwargs)
        super(*args, **kwargs)

        @api_key = kwargs[:api_key] || Mihari.config.shodan_api_key
      end

      def artifacts
        results = search
        return [] unless results || results.empty?

        results = results.map { |result| Structs::Shodan::Result.from_dynamic!(result) }
        matches = results.map { |result| result.matches || [] }.flatten

        uniq_matches = matches.uniq(&:ip_str)
        uniq_matches.map { |match| build_artifact(match, matches) }
      end

      private

      PAGE_SIZE = 100

      def configuration_keys
        %w[shodan_api_key]
      end

      def api
        @api ||= ::Shodan::API.new(key: api_key)
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
      # Collect metadata from matches
      #
      # @param [Array<Structs::Shodan::Match>] matches
      # @param [String] ip
      #
      # @return [Array<Hash>]
      #
      def collect_metadata_by_ip(matches, ip)
        matches.select { |match| match.ip_str == ip }.map(&:metadata)
      end

      #
      # Collect ports from matches
      #
      # @param [Array<Structs::Shodan::Match>] matches
      # @param [String] ip
      #
      # @return [Array<String>]
      #
      def collect_ports_by_ip(matches, ip)
        matches.select { |match| match.ip_str == ip }.map(&:port)
      end

      #
      # Collect hostnames from matches
      #
      # @param [Array<Structs::Shodan::Match>] matches
      # @param [String] ip
      #
      # @return [Array<String>]
      #
      def collect_hostnames_by_ip(matches, ip)
        matches.select { |match| match.ip_str == ip }.map(&:hostnames).flatten.uniq
      end

      #
      # Build an artifact from a Shodan search API response
      #
      # @param [Structs::Shodan::Match] match
      # @param [Array<Structs::Shodan::Match>] matches
      #
      # @return [Artifact]
      #
      def build_artifact(match, matches)
        as = nil
        as = AutonomousSystem.new(asn: normalize_asn(match.asn)) unless match.asn.nil?

        geolocation = nil
        if !match.location.country_name.nil? && !match.location.country_code.nil?
          geolocation = Geolocation.new(
            country: match.location.country_name,
            country_code: match.location.country_code
          )
        end

        metadata = collect_metadata_by_ip(matches, match.ip_str)

        ports = collect_ports_by_ip(matches, match.ip_str).map do |port|
          Port.new(port: port)
        end

        reverse_dns_names = collect_hostnames_by_ip(matches, match.ip_str).map do |name|
          ReverseDnsName.new(name: name)
        end

        Artifact.new(
          data: match.ip_str,
          source: source,
          metadata: metadata,
          autonomous_system: as,
          geolocation: geolocation,
          ports: ports,
          reverse_dns_names: reverse_dns_names
        )
      end
    end
  end
end
