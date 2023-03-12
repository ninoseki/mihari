# frozen_string_literal: true

module Mihari
  module Clients
    class Onyphe < Base
      # @return [String]
      attr_reader :api_key

      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [Hash] headers
      #
      def initialize(base_url = "https://www.onyphe.io", api_key:, headers: {})
        raise(ArgumentError, "'api_key' argument is required") if api_key.nil?

        super(base_url, headers: headers)

        @api_key = api_key
      end

      #
      # @param [String] query
      # @param [Integer] page
      #
      # @return [Hash]
      #
      def datascan(query, page: 1)
        params = { page: page, apikey: api_key }
        res = get("/api/v2/simple/datascan/#{query}", params: params)
        Structs::Onyphe::Response.from_dynamic! JSON.parse(res.body.to_s)
      end
    end
  end
end
