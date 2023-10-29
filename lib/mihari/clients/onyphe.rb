# frozen_string_literal: true

module Mihari
  module Clients
    #
    # Onyphe API client
    #
    class Onyphe < Base
      PAGE_SIZE = 10

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
        base_url = "https://www.onyphe.io",
        api_key:,
        headers: {},
        pagination_interval: Mihari.config.pagination_interval,
        timeout: nil
      )
        raise(ArgumentError, "api_key is required") if api_key.nil?

        super(base_url, headers: headers, pagination_interval: pagination_interval, timeout: timeout)

        @api_key = api_key
      end

      #
      # @param [String] query
      # @param [Integer] page
      #
      # @return [Structs::Onyphe::Response]
      #
      def datascan(query, page: 1)
        params = { page: page, apikey: api_key }
        res = get("/api/v2/simple/datascan/#{query}", params: params)
        Structs::Onyphe::Response.from_dynamic! JSON.parse(res.body.to_s)
      end

      #
      # @param [String] query
      # @param [Integer] pagination_limit
      #
      # @return [Enumerable<Structs::Onyphe::Response>]
      #
      def datascan_with_pagination(query, pagination_limit: Mihari.config.pagination_limit)
        Enumerator.new do |y|
          (1..pagination_limit).each do |page|
            res = datascan(query, page: page)

            y.yield res

            break if res.total <= page * PAGE_SIZE

            sleep_pagination_interval
          end
        end
      end
    end
  end
end
