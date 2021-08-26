# frozen_string_literal: true

require "onyphe"
require "normalize_country"

module Mihari
  module Analyzers
    class Onyphe < Base
      param :query
      option :title, default: proc { "Onyphe search" }
      option :description, default: proc { "query = #{query}" }
      option :tags, default: proc { [] }

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

      def api
        @api ||= ::Onyphe::API.new(Mihari.config.onyphe_api_key)
      end

      def search_with_page(query, page: 1)
        res = api.simple.datascan(query, page: page)
        Structs::Onyphe::Response.from_dynamic!(res)
      end

      def search
        responses = []
        (1..Float::INFINITY).each do |page|
          res = search_with_page(query, page: page)
          responses << res

          total = res.total
          break if total <= page * PAGE_SIZE
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
          autonomous_system: as,
          geolocation: geolocation
        )
      end
    end
  end
end
