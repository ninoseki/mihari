# frozen_string_literal: true

module Mihari
  module Analyzers
    module Clients
      class OTX
        attr_reader :api_key

        def initialize(api_key)
          @api_key = api_key
        end

        def query_by_ip(ip)
          get "https://otx.alienvault.com/api/v1/indicators/IPv4/#{ip}/passive_dns"
        end

        def query_by_domain(domain)
          get "https://otx.alienvault.com/api/v1/indicators/domain/#{domain}/passive_dns"
        end

        private

        def headers
          { "x-otx-api-key": api_key }
        end

        def get(url)
          res = HTTP.get(url, headers: headers)
          JSON.parse(res.body.to_s)
        rescue HTTPError
          nil
        end
      end
    end
  end
end
