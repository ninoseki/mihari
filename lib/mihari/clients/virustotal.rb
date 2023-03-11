# frozen_string_literal: true

module Mihari
  module Clients
    class VirusTotal < Base
      #
      # @param [String] base_url
      # @param [String] id
      # @param [String] secret
      # @param [Hash] headers
      #
      def initialize(base_url = "https://www.virustotal.com", api_key:, headers: {})
        raise(ArgumentError, "'api_key' argument is required") if api_key.nil?

        headers["x-apikey"] = api_key

        super(base_url, headers: headers)
      end

      #
      # @param [String] query
      #
      def domain_search(query)
        _get("/api/v3/domains/#{query}/resolutions")
      end

      #
      # @param [String] query
      #
      def ip_search(query)
        _get("/api/v3/ip_addresses/#{query}/resolutions")
      end

      #
      # @param [String] query
      # @param [String, nil] cursor
      #
      def intel_search(query, cursor: nil)
        params = { query: query, cursor: cursor }.compact
        _get("/api/v3/intelligence/search", params: params)
      end

      private

      #
      #
      # @param [String] path
      # @param [Hash] params
      #
      def _get(path, params: {})
        res = get(path, params: params)
        JSON.parse(res.body.to_s)
      end
    end
  end
end
