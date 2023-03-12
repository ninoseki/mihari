# frozen_string_literal: true

module Mihari
  module Clients
    class BinaryEdge < Base
      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [Hash] headers
      #
      def initialize(base_url = "https://api.binaryedge.io/v2", api_key:, headers: {})
        raise(ArgumentError, "'api_key' argument is required") unless api_key

        headers["x-key"] = api_key

        super(base_url, headers: headers)
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
    end
  end
end
