# frozen_string_literal: true

module Mihari
  module Clients
    class PulseDive < Base
      attr_reader :api_key

      def initialize(base_url = "https://pulsedive.com", api_key:, headers: {})
        super(base_url, headers: headers)

        @api_key = api_key

        raise(ArgumentError, "'api_key' argument is required") unless api_key
      end

      def get_indicator(ip_or_domain)
        _get "/api/info.php", params: { indicator: ip_or_domain }
      end

      def get_properties(indicator_id)
        _get "/api/info.php", params: { iid: indicator_id, get: "properties" }
      end

      private

      #
      #
      # @param [String] path
      # @param [Hash] params
      #
      def _get(path, params: {})
        params["key"] = api_key

        res = get(path, params: params)
        JSON.parse(res.body.to_s)
      rescue HTTPError
        nil
      end
    end
  end
end
