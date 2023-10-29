# frozen_string_literal: true

module Mihari
  module Clients
    #
    # BinaryEdge API client
    #
    class BinaryEdge < Base
      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [Hash] headers
      # @param [Integer, nil] timeout
      # @param [Integer] pagination_interval
      #
      def initialize(
        base_url = "https://api.binaryedge.io/v2",
        api_key:,
        headers: {},
        pagination_interval: Mihari.config.pagination_interval,
        timeout: nil
      )
        headers["x-key"] = api_key

        super(base_url, headers: headers, timeout: timeout, pagination_interval: pagination_interval)
      end

      #
      # @param [String] query String used to query our data
      # @param [Integer] page Default 1, Maximum: 500
      # @param [Integer, nil] only_ips If selected, only output IP addresses, ports and protocols.
      #
      # @return [Structs::BinaryEdge::Response]
      #
      def search(query, page: 1, only_ips: nil)
        params = {
          query: query,
          page: page,
          only_ips: only_ips
        }.compact

        res = get("/query/search", params: params)
        Structs::BinaryEdge::Response.from_dynamic! JSON.parse(res.body.to_s)
      end

      #
      # @param [String] query
      # @param [Integer, nil] only_ips
      # @param [Integer] pagination_limit
      #
      # @return [Enumerable<Structs::BinaryEdge::Response>]
      #
      def search_with_pagination(query, only_ips: nil, pagination_limit: Mihari.config.pagination_limit)
        Enumerator.new do |y|
          (1..pagination_limit).each do |page|
            res = search(query, page: page, only_ips: only_ips)

            y.yield res

            break if res.events.length < res.pagesize

            sleep_pagination_interval
          end
        end
      end
    end
  end
end
