# frozen_string_literal: true

module Mihari
  module Clients
    class MISP < Base
      #
      # @param [String] base_url
      # @param [String] api_key
      # @param [Hash] headers
      #
      def initialize(base_url, api_key:, headers: {})
        raise(ArgumentError, "'api_key' argument is required") unless api_key

        headers["authorization"] = api_key
        super(base_url, headers: headers)
      end

      def create_event(payload)
        _post("/events/add", json: payload)
      end

      private

      #
      #
      # @param [String] path
      # @param [Hash] params
      #
      def _post(path, json: {})
        res = post(path, json: json)
        JSON.parse(res.body.to_s)
      end
    end
  end
end
