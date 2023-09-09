# frozen_string_literal: true

module Mihari
  module Clients
    class BinaryEdge < Base
      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [Hash] headers
      # @param [Integer.nil ] interval
      #
      def initialize(base_url = "https://api.binaryedge.io/v2", api_key:, headers: {}, interval: nil)
        raise(ArgumentError, "'api_key' argument is required") unless api_key

        headers["x-key"] = api_key

        super(base_url, headers: headers, interval: interval)
      end

      #
      # @param [String] query String used to query our data
      # @param [Integer] page Default 1, Maximum: 500
      # @param [Integer, nil] only_ips If selected, only output IP addresses, ports and protocols.
      #
      # @return [Hash]
      #
      def search(query, page: 1, only_ips: nil)
        params = {
          query: query,
          page: page,
          only_ips: only_ips
        }.compact

        res = get("/query/search", params: params)
        JSON.parse(res.body.to_s)
      end

      #
      # @param [String] query
      # @param [Integer, nil] only_ips
      # @param [Integer] pagination_limit
      #
      # @return [Enumerable<Hash>]
      #
      def search_with_pagination(query, only_ips: nil, pagination_limit: Mihari.config.pagination_limit)
        Enumerator.new do |y|
          (1..pagination_limit).each do |page|
            res = search(query, page: page, only_ips: only_ips)

            page_size = res["pagesize"].to_i
            events = res["events"] || []

            y.yield res

            break if events.length < page_size

            sleep_interval
          end
        end
      end
    end
  end
end
