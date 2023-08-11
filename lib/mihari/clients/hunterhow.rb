# frozen_string_literal: true

require "base64"

module Mihari
  module Clients
    class HunterHow < Base
      # @return [String]
      attr_reader :api_key

      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [Hash] headers
      #
      def initialize(base_url = "https://api.hunter.how/", api_key:, headers: {})
        raise(ArgumentError, "'api_key' argument is required") unless api_key

        super(base_url, headers: headers)

        @api_key = api_key
      end

      #
      # @param [String] query String used to query our data
      # @param [Integer] page Default 1, Maximum: 500
      # @param [Integer] page_size Default 100, Maximum: 100
      # @param [String] start_time
      # @param [String] end_time
      #
      # @return [Structs::HunterHow::Response]
      #
      def search(query, start_time:, end_time:, page: 1, page_size: 10)
        params = {
          query: Base64.urlsafe_encode64(query),
          page: page,
          page_size: page_size,
          start_time: start_time,
          end_time: end_time,
          "api-key": api_key
        }.compact
        res = get("/search", params: params)
        Structs::HunterHow::Response.from_dynamic! JSON.parse(res.body.to_s)
      end
    end
  end
end
