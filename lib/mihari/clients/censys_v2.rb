# frozen_string_literal: true

module Mihari
  module Clients
    # Censys Platform API (v3) client
    class CensysV2 < Base
      BASE_URL = "https://api.platform.censys.io/v3/global/"

      attr_reader :api_key, :organization_id

      def initialize(api_key:, organization_id: nil, headers: {}, pagination_interval: Mihari.config.pagination_interval, timeout: nil)
        raise(ArgumentError, "api_key is required") if api_key.nil?
        headers["Authorization"] = "Bearer #{api_key}"
        headers["Accept"] = "application/vnd.censys.api.v3.host.v1+json"
        headers["X-Organization-ID"] = organization_id if organization_id
        super(BASE_URL, headers: headers, pagination_interval: pagination_interval, timeout: timeout)
      end

      def search(query, size: nil, cursor: nil)
        params = {query: query, page_size: size, page_token: cursor}.compact
        Structs::CensysV2::Response.from_dynamic! post_json("search/query", json: params)
      end

      def search_with_pagination(query, size: nil, pagination_limit: Mihari.config.pagination_limit)
        cursor = nil
        Enumerator.new do |y|
          pagination_limit.times do
            res = search(query, size: size, cursor: cursor)
            y.yield res
            cursor = res.result&.next_page_token
            break if cursor.nil? || cursor.empty?
            sleep_pagination_interval
          end
        end
      end
    end
  end
end
