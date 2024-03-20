# frozen_string_literal: true

module Mihari
  module Clients
    #
    # Yeti API client
    #
    class Yeti < Base
      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [Hash] headers
      # @param [Integer, nil] timeout
      #
      def initialize(base_url, api_key:, headers: {}, timeout: nil)
        raise(ArgumentError, "api_key is required") unless api_key

        headers["x-yeti-apikey"] = api_key
        super(base_url, headers:, timeout:)
      end

      def get_token
        res = post_json("/api/v2/auth/api-token")
        res["access_token"]
      end

      #
      # @param [Hash] json
      #
      # @return [Hash]
      #
      def create_observables(json)
        token = get_token
        post_json("/api/v2/observables/bulk", json:, headers: {authorization: "Bearer #{token}"})
      end
    end
  end
end
