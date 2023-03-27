# frozen_string_literal: true

module Mihari
  module Clients
    class MISP < Base
      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [Hash] headers
      #
      def initialize(base_url, api_key:, headers: {})
        raise(ArgumentError, "'api_key' argument is required") unless api_key

        headers["authorization"] = api_key
        headers["accept"] = "application/json"

        super(base_url, headers: headers)
      end

      #
      # @param [Hash] payload
      #
      # @return [Hash]
      #
      def create_event(payload)
        res = post("/events/add", json: payload)
        JSON.parse(res.body.to_s)
      end
    end
  end
end
