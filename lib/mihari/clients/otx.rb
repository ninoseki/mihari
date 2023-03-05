# frozen_string_literal: true

module Mihari
  module Clients
    class OTX < Base
      def initialize(base_url = "https://otx.alienvault.com", api_key:, headers: {})
        raise(ArgumentError, "'api_key' argument is required") unless api_key

        headers["x-otx-api-key"] = api_key
        super(base_url, headers: headers)
      end

      def query_by_ip(ip)
        _get "/api/v1/indicators/IPv4/#{ip}/passive_dns"
      end

      def query_by_domain(domain)
        _get "/api/v1/indicators/domain/#{domain}/passive_dns"
      end

      private

      def _get(path)
        res = get(path)
        JSON.parse(res.body.to_s)
      rescue HTTPError
        nil
      end
    end
  end
end
