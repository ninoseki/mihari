# frozen_string_literal: true

module Mihari
  module Clients
    class OTX < Base
      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [Hash] headers
      #
      def initialize(base_url = "https://otx.alienvault.com", api_key:, headers: {})
        raise(ArgumentError, "'api_key' argument is required") unless api_key

        headers["x-otx-api-key"] = api_key
        super(base_url, headers: headers)
      end

      #
      # @param [String] ip
      #
      # @return [Hash]
      #
      def query_by_ip(ip)
        _get "/api/v1/indicators/IPv4/#{ip}/passive_dns"
      end

      #
      # @param [String] domain
      #
      # @return [Hash]
      #
      def query_by_domain(domain)
        _get "/api/v1/indicators/domain/#{domain}/passive_dns"
      end

      private

      #
      # @param [String] path
      #
      # @return [Hash]
      #
      def _get(path)
        res = get(path)
        JSON.parse(res.body.to_s)
      end
    end
  end
end
