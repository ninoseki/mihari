# frozen_string_literal: true

module Mihari
  module Clients
    class TheHive < Base
      #
      # @param [String] base_url
      # @param [String] api_key
      # @param [String, nil] api_version
      # @param [Hash] headers
      #
      def initialize(base_url, api_key:, api_version:, headers: {})
        raise(ArgumentError, "'api_key' argument is required") unless api_key

        base_url += "/#{api_version}" unless api_version.nil?
        headers["authorization"] = "Bearer #{api_key}"

        super(base_url, headers: headers)
      end

      def alert(json)
        json = json.to_camelback_keys.compact
        res = post("/alert", json: json)
        JSON.parse(res.body.to_s)
      end
    end
  end
end
