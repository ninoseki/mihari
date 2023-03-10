# frozen_string_literal: true

module Mihari
  module Clients
    class Shodan < Base
      attr_reader :api_key

      def initialize(base_url = "https://api.shodan.io", api_key:, headers: {})
        raise(ArgumentError, "'api_key' argument is required") unless api_key

        super(base_url, headers: headers)

        @api_key = api_key
      end

      # Search Shodan using the same query syntax as the website and use facets
      # to get summary information for different properties.
      def search(query, page: 1, minify: true)
        params = {
          query: query,
          page: page,
          minify: minify,
          key: api_key
        }
        _get("/shodan/host/search", params: params)
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
