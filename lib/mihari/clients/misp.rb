# frozen_string_literal: true

module Mihari
  module Clients
    class MISP < Base
      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [Hash] headers
      # @param [Integer, nil] timeout
      #
      def initialize(base_url, api_key:, headers: {}, timeout: nil)
        raise(ArgumentError, "api_key is required") unless api_key

        headers["authorization"] = api_key
        headers["accept"] = "application/json"

        super(base_url, headers: headers, timeout: timeout)
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
