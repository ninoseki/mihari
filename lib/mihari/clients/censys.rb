# frozen_string_literal: true

require "base64"

module Mihari
  module Clients
    #
    # Censys API client
    #
    module Censys
      class V3 < Base
        def initialize(base_url = "https://api.platform.censys.io", pat:, organization_id:, headers: {}, pagination_interval: Mihari.config.pagination_interval, timeout: nil)
          raise(ArgumentError, "pat is required") if pat.nil?
          raise(ArgumentError, "organization_id is required") if organization_id.nil?

          headers["Authorization"] = "Bearer #{pat}"
          headers["Accept"] = "application/vnd.censys.api.v3.host.v1+json"
          headers["X-Organization-ID"] = organization_id

          super(base_url, headers: headers, pagination_interval: pagination_interval, timeout: timeout)
        end

        def search(query, page_size: nil, page_token: nil)
          json = {query: query, page_size:, page_token:}.compact
          Structs::Censys::V3::Response.from_dynamic! post_json("/v3/global/search/query", json:)
        end

        def search_with_pagination(query, page_size: nil, pagination_limit: Mihari.config.pagination_limit)
          page_token = nil
          Enumerator.new do |y|
            pagination_limit.times do
              res = search(query, page_size:, page_token:)
              y.yield res
              page_token = res.result&.next_page_token
              break if page_token.nil? || page_token.empty?
              sleep_pagination_interval
            end
          end
        end
      end
    end
  end
end
