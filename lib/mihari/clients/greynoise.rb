# frozen_string_literal: true

module Mihari
  module Clients
    class GreyNoise < Base
      PAGE_SIZE = 10_000

      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [Hash] headers
      # @param [Integer] pagination_interval
      # @param [Integer, nil] timeout
      #
      def initialize(
        base_url = "https://api.greynoise.io",
        api_key:,
        headers: {},
        pagination_interval: Mihari.config.pagination_interval,
        timeout: nil
      )
        raise(ArgumentError, "api_key is required") unless api_key

        headers["key"] = api_key
        super(base_url, headers: headers, pagination_interval: pagination_interval, timeout: timeout)
      end

      #
      # GNQL (GreyNoise Query Language) is a domain-specific query language that uses Lucene deep under the hood
      #
      # @param [String] query GNQL query string
      # @param [Integer] size Maximum amount of results to grab
      # @param [Integer, nil] scroll Scroll token to paginate through results
      #
      # @return [Hash]
      #
      def gnql_search(query, size: PAGE_SIZE, scroll: nil)
        params = { query: query, size: size, scroll: scroll }.compact
        res = get("/v2/experimental/gnql", params: params)
        Structs::GreyNoise::Response.from_dynamic! JSON.parse(res.body.to_s)
      end

      #
      # @param [String] query
      # @param [Integer] size
      # @param [Integer] pagination_limit
      #
      # @return [Enumerable<Structs::GreyNoise::Response>]
      #
      def gnql_search_with_pagination(query, size: PAGE_SIZE, pagination_limit: Mihari.config.pagination_limit)
        scroll = nil

        Enumerator.new do |y|
          pagination_limit.times do
            res = gnql_search(query, size: size, scroll: scroll)

            y.yield res

            scroll = res.scroll
            break if scroll.nil?

            sleep_pagination_interval
          end
        end
      end
    end
  end
end
