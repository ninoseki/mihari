# frozen_string_literal: true

module Mihari
  module Clients
    class GreyNoise < Base
      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [Hash] headers
      #
      def initialize(base_url = "https://api.greynoise.io", api_key:, headers: {})
        raise(ArgumentError, "'api_key' argument is required") unless api_key

        headers["key"] = api_key
        super(base_url, headers: headers)
      end

      #
      # GNQL (GreyNoise Query Language) is a domain-specific query language that uses Lucene deep under the hood
      #
      # @param [String] query GNQL query string
      # @param [Integer, nil] size Maximum amount of results to grab
      # @param [Integer, nil] scroll Scroll token to paginate through results
      #
      # @return [Hash]
      #
      def gnql_search(query, size: nil, scroll: nil)
        params = { query: query, size: size, scroll: scroll }.compact
        res = get("/v2/experimental/gnql", params: params)
        Structs::GreyNoise::Response.from_dynamic! JSON.parse(res.body.to_s)
      end
    end
  end
end
