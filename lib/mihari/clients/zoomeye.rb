# frozen_string_literal: true

module Mihari
  module Clients
    class ZoomEye < Base
      PAGE_SIZE = 10

      attr_reader :api_key

      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [Hash] headers
      # @param [Integer, nil] interval
      #
      def initialize(base_url = "https://api.zoomeye.org", api_key:, headers: {}, interval: nil)
        raise(ArgumentError, "'api_key' argument is required") unless api_key

        headers["api-key"] = api_key
        super(base_url, headers: headers, interval: interval)
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
      # @param [String] query
      # @param [String, nil] facets
      # @param [Integer] pagination_limit
      #
      # @return [Enumerable<Hash>]
      #
      def host_search_with_pagination(query, facets: nil, pagination_limit: Mihari.config.pagination_limit)
        Enumerator.new do |y|
          (1..pagination_limit).each do |page|
            res = host_search(query, facets: facets, page: page)

            break if res.nil?

            y.yield res

            total = res["total"].to_i
            break if total <= page * PAGE_SIZE

            sleep_interval
          end
        end
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

      #
      # @param [String] query
      # @param [String, nil] facets
      # @param [Integer] pagination_limit
      #
      # @return [Enumerable<Hash>]
      #
      def web_search_with_pagination(query, facets: nil, pagination_limit: Mihari.config.pagination_limit)
        Enumerator.new do |y|
          (1..pagination_limit).each do |page|
            res = web_search(query, facets: facets, page: page)

            break if res.nil?

            y.yield res

            total = res["total"].to_i
            break if total <= page * PAGE_SIZE

            sleep_interval
          end
        end
      end

      private

      #
      # @param [String] path
      # @param [Hash] params
      #
      # @return [Hash, nil]
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
