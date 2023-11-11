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
        get_json "/api/info.php", params: { indicator: ip_or_domain, key: api_key }
      end

      #
      # @param [String] indicator_id
      #
      # @return [Hash]
      #
      def get_properties(indicator_id)
        get_json "/api/info.php", params: { iid: indicator_id, get: "properties", key: api_key }
      end
    end
  end
end
