# frozen_string_literal: true

module Mihari
  module Clients
    class ZoomEye < Base
      attr_reader :api_key

      def initialize(base_url = "https://api.zoomeye.org", api_key:, headers: {})
        raise(ArgumentError, "'api_key' argument is required") unless api_key

        headers["api-key"] = api_key
        super(base_url, headers: headers)
      end

      #
      # Search the Host devices
      #
      # @param [String] query Query string
      # @param [Integer, nil] page The page number to paging(default:1)
      # @param [String, nil] facets A comma-separated list of properties to get summary information on query
      #
      # @return [Hash]
      #
      def host_search(query, page: nil, facets: nil)
        params = {
          query: query,
          page: page,
          facets: facets
        }.compact

        _get("/host/search", params: params)
      end

      #
      # Search the Web technologies
      #
      # @param [String] query Query string
      # @param [Integer, nil] page The page number to paging(default:1)
      # @param [String, nil] facets A comma-separated list of properties to get summary information on query
      #
      # @return [Hash]
      #
      def web_search(query, page: nil, facets: nil)
        params = {
          query: query,
          page: page,
          facets: facets
        }.compact

        _get("/web/search", params: params)
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
      rescue HTTPError
        nil
      end
    end
  end
end
