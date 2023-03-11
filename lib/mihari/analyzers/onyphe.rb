# frozen_string_literal: true

require "normalize_country"

module Mihari
  module Analyzers
    class Onyphe < Base
      param :query

      option :interval, default: proc { 0 }

      # @return [String, nil]
      attr_reader :api_key

      def initialize(*args, **kwargs)
        super(*args, **kwargs)

        @api_key = kwargs[:api_key] || Mihari.config.onyphe_api_key
      end

      def artifacts
        responses = search
        return [] unless responses

        results = responses.map(&:results).flatten
        results.map do |result|
          build_artifact result
        end
      end

      private

      PAGE_SIZE = 10

      def configuration_keys
        %w[onyphe_api_key]
      end

      def client
        @client ||= Clients::Onyphe.new(api_key: api_key)
      end

      #
      # Search with pagination
      #
      # @param [String] query
      # @param [Integer] page
      #
      # @return [Structs::Onyphe::Response]
      #
      def search_with_page(query, page: 1)
        res = client.datascan(query, page: page)
        Structs::Onyphe::Response.from_dynamic!(res)
      end

      #
      # Search
      #
      # @return [Array<Structs::Onyphe::Response>]
      #
      def search
        responses = []
        (1..Float::INFINITY).each do |page|
          res = search_with_page(query, page: page)
          responses << res

          total = res.total
          break if total <= page * PAGE_SIZE

          # sleep #{interval} seconds to avoid the rate limitation (if it is set)
          sleep interval
        end
        responses
      end

      #
      # Build an artifact from an Onyphe search API result
      #
      # @param [Structs::Onyphe::Result] result
      #
      # @return [Artifact]
      #
      def build_artifact(result)
        as = AutonomousSystem.new(asn: normalize_asn(result.asn))

        geolocation = nil
        unless result.country_code.nil?
          geolocation = Geolocation.new(
            country: NormalizeCountry(result.country_code, to: :short),
            country_code: result.country_code
          )
        end

        Artifact.new(
          data: result.ip,
          source: source,
          metadata: result.metadata,
          autonomous_system: as,
          geolocation: geolocation
        )
      end
    end
  end
end
