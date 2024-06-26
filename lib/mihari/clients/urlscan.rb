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

        super(base_url, headers:, pagination_interval:, timeout:)
      end

      #
      # @param [String] q
      # @param [Integer, nil] size
      # @param [String, nil] search_after
      #
      # @return [Mihari::Structs::Urlscan::Response]
      #
      def search(q, size: nil, search_after: nil)
        params = {q:, size:, search_after:}.compact
        Structs::Urlscan::Response.from_dynamic! get_json("/api/v1/search/", params:)
      end

      #
      # @param [String] q
      # @param [Integer, nil] size
      # @param [Integer] pagination_limit
      #
      # @return [Enumerable<Mihari::Structs::Urlscan::Response>]
      #
      def search_with_pagination(q, size: nil, pagination_limit: Mihari.config.pagination_limit)
        search_after = nil

        Enumerator.new do |y|
          pagination_limit.times do
            res = search(q, size:, search_after:)

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
