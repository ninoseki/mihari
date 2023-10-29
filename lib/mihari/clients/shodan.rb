# frozen_string_literal: true

module Mihari
  module Clients
    #
    # Shodan API client
    #
    class Shodan < Base
      PAGE_SIZE = 100

      # @return [String]
      attr_reader :api_key

      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [Hash] headers
      # @param [Integer] pagination_interval
      # @param [Integer, nil] timeout
      #
      def initialize(
        base_url = "https://api.shodan.io",
        api_key:,
        headers: {},
        pagination_interval: Mihari.config.pagination_interval,
        timeout: nil
      )
        raise(ArgumentError, "api_key is required") unless api_key

        super(base_url, headers: headers, pagination_interval: pagination_interval, timeout: timeout)

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
        Structs::Shodan::Response.from_dynamic! JSON.parse(res.body.to_s)
      end

      #
      # @param [String] query
      # @param [Boolean] minify
      # @param [Integer] pagination_limit
      #
      # @return [Enumerable<Structs::Shodan::Response>]
      #
      def search_with_pagination(query, minify: true, pagination_limit: Mihari.config.pagination_limit)
        Enumerator.new do |y|
          (1..pagination_limit).each do |page|
            res = search(query, page: page, minify: minify)

            y.yield res

            break if res.total <= page * PAGE_SIZE

            sleep_pagination_interval
          rescue JSON::ParserError
            # ignore JSON::ParserError
            # ref. https://github.com/ninoseki/mihari/issues/197
            next
          end
        end
      end
    end
  end
end
