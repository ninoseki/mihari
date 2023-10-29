# frozen_string_literal: true

module Mihari
  module Clients
    #
    # urlscan.io API client
    #
    class Urlscan < Base
      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [Hash] headers
      # @param [Integer, nil] pagination_interval
      # @param [Integer, nil] timeout
      #
      def initialize(
        base_url = "https://urlscan.io",
        api_key:,
        headers: {},
        pagination_interval: Mihari.config.pagination_interval,
        timeout: nil
      )
        raise(ArgumentError, "api_key is required") if api_key.nil?

        headers["api-key"] = api_key

        super(base_url, headers: headers, pagination_interval: pagination_interval, timeout: timeout)
      end

      #
      # @param [String] q
      # @param [Integer, nil] size
      # @param [String, nil] search_after
      #
      # @return [Structs::Urlscan::Response]
      #
      def search(q, size: nil, search_after: nil)
        params = { q: q, size: size, search_after: search_after }.compact
        res = get("/api/v1/search/", params: params)
        Structs::Urlscan::Response.from_dynamic! JSON.parse(res.body.to_s)
      end

      #
      # @param [String] q
      # @param [Integer, nil] size
      # @param [Integer] pagination_limit
      #
      # @return [Enumerable<Structs::Urlscan::Response>]
      #
      def search_with_pagination(q, size: nil, pagination_limit: Mihari.config.pagination_limit)
        search_after = nil

        Enumerator.new do |y|
          pagination_limit.times do
            res = search(q, size: size, search_after: search_after)

            y.yield res

            break unless res.has_more

            search_after = res.results.last.sort.join(",")

            sleep_pagination_interval
          end
        end
      end
    end
  end
end
