# frozen_string_literal: true

module Mihari
  module Clients
    #
    # TheHive API client
    #
    class TheHive < Base
      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [String, nil] api_version
      # @param [Hash] headers
      # @param [Integer, nil] timeout
      #
      def initialize(base_url, api_key:, api_version:, headers: {}, timeout: nil)
        raise(ArgumentError, "api_key is required") unless api_key

        base_url += "/#{api_version}" unless api_version.nil?
        headers["authorization"] = "Bearer #{api_key}"

        super(base_url, headers: headers, timeout: timeout)
      end

      #
      # @param [Hash] json
      #
      # @return [Hash]
      #
      def alert(json)
        json = json.to_camelback_keys.compact
        res = post("/alert", json: json)
        JSON.parse(res.body.to_s)
      end
    end
  end
end
