# frozen_string_literal: true

module Mihari
  module Clients
    #
    # TheHive API client
    #
    class TheHive < Base
      attr_reader :api_version

      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [String] api_version
      # @param [Hash] headers
      # @param [Integer, nil] timeout
      #
      def initialize(base_url, api_key:, api_version: "v1", headers: {}, timeout: nil)
        raise(ArgumentError, "api_key is required") unless api_key

        headers["authorization"] = "Bearer #{api_key}"
        super(base_url, headers:, timeout:)

        @api_version = api_version
      end

      #
      # @param [Hash] json
      #
      # @return [Hash]
      #
      def alert(json)
        json = json.to_camelback_keys.compact
        post_json("/api/#{api_version}/alert", json:)
      end
    end
  end
end
