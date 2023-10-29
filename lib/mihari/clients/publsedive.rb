# frozen_string_literal: true

module Mihari
  module Clients
    #
    # PulseDive API client
    #
    class PulseDive < Base
      # @return [String]
      attr_reader :api_key

      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [Hash] headers
      # @param [Integer, nil] timeout
      #
      def initialize(base_url = "https://pulsedive.com", api_key:, headers: {}, timeout: nil)
        raise(ArgumentError, "api_key is required") unless api_key

        @api_key = api_key

        super(base_url, headers: headers, timeout: timeout)
      end

      #
      # @param [String] ip_or_domain
      #
      # @return [Hash]
      #
      def get_indicator(ip_or_domain)
        _get "/api/info.php", params: { indicator: ip_or_domain }
      end

      #
      # @param [String] indicator_id
      #
      # @return [Hash]
      #
      def get_properties(indicator_id)
        _get "/api/info.php", params: { iid: indicator_id, get: "properties" }
      end

      private

      #
      # @param [String] path
      # @param [Hash] params
      #
      # @return [Hash]
      #
      def _get(path, params: {})
        params["key"] = api_key

        res = get(path, params: params)
        JSON.parse res.body.to_s
      end
    end
  end
end
