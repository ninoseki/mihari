# frozen_string_literal: true

module Mihari
  module Clients
    class UrlScan < Base
      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [Hash] headers
      #
      def initialize(base_url = "https://urlscan.io", api_key:, headers: {})
        raise(ArgumentError, "'api_key' argument is required") if api_key.nil?

        headers["api-key"] = api_key

        super(base_url, headers: headers)
      end

      #
      # @param [String] q
      # @param [Integer] size
      # @param [String, nil] search_after
      #
      # @return [Hash]
      #
      def search(q, size: 100, search_after: nil)
        params = { q: q, size: size, search_after: search_after }.compact
        res = get("/api/v1/search/", params: params)
        JSON.parse res.body.to_s
      end
    end
  end
end
