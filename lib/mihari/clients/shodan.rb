# frozen_string_literal: true

module Mihari
  module Clients
    class Shodan < Base
      # @return [String]
      attr_reader :api_key

      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [Hash] headers
      #
      def initialize(base_url = "https://api.shodan.io", api_key:, headers: {})
        raise(ArgumentError, "'api_key' argument is required") unless api_key

        super(base_url, headers: headers)

        @api_key = api_key
      end

      #
      # @param [String] query
      # @param [Integer] page
      # @param [Boolean] minify
      #
      # @return [Structs::Shodan::Result]
      #
      def search(query, page: 1, minify: true)
        params = {
          query: query,
          page: page,
          minify: minify,
          key: api_key
        }
        res = get("/shodan/host/search", params: params)
        Structs::Shodan::Result.from_dynamic! JSON.parse(res.body.to_s)
      end
    end
  end
end
