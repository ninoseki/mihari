# frozen_string_literal: true

require "base64"

module Mihari
  module Clients
    #
    # Censys API client
    #
    module Censys
      class V2 < Base
        #
        # @param [String] base_url
        # @param [String, nil] id
        # @param [String, nil] secret
        # @param [Hash] headers
        # @param [Integer] pagination_interval
        # @param [Integer, nil] timeout
        #
        def initialize(
          base_url = "https://search.censys.io",
          id:,
          secret:,
          headers: {},
          pagination_interval: Mihari.config.pagination_interval,
          timeout: nil
        )
          raise(ArgumentError, "id is required") if id.nil?
          raise(ArgumentError, "secret is required") if secret.nil?

          headers["authorization"] = "Basic #{Base64.strict_encode64("#{id}:#{secret}")}"

          super(base_url, headers:, pagination_interval:, timeout:)
        end

        #
        # Search current index.
        #
        # Searches the given index for all records that match the given query.
        # For more details, see our documentation: https://search.censys.io/api/v2/docs
        #
        # @param [String] query the query to be executed.
        # @param [Integer, nil] per_page the number of results to be returned for each page.
        # @param [Integer, nil] cursor the cursor of the desired result set.
        #
        # @return [Mihari::Structs::Censys::Response]
        #
        def search(query, per_page: nil, cursor: nil)
          params = {q: query, per_page:, cursor:}.compact
          Structs::Censys::V2::Response.from_dynamic! get_json("/api/v2/hosts/search", params:)
        end

        #
        # @param [String] query
        # @param [Integer, nil] per_page
        # @param [Integer] pagination_limit
        #
        # @return [Enumerable<Mihari::Structs::Censys::Response>]
        #
        def search_with_pagination(query, per_page: nil, pagination_limit: Mihari.config.pagination_limit)
          cursor = nil

          Enumerator.new do |y|
            pagination_limit.times do
              res = search(query, per_page:, cursor:)

              y.yield res

              cursor = res.result.links.next
              # NOTE: Censys's search API is unstable recently
              # it may returns empty links or empty string cursors
              # - Empty links: "links": {}
              # - Empty cursors: "links": { "next": "", "prev": "" }
              # So it needs to check both cases
              break if cursor.nil? || cursor.empty?

              sleep_pagination_interval
            end
          end
        end
      end

      class V3 < Base
        BASE_URL = "https://api.platform.censys.io"

        def initialize(pat:, organization_id: nil, headers: {}, pagination_interval: Mihari.config.pagination_interval, timeout: nil)
          raise(ArgumentError, "pat is required") if pat.nil?
          raise(ArgumentError, "organization_id is required") if organization_id.nil?

          headers["Authorization"] = "Bearer #{pat}"
          headers["Accept"] = "application/vnd.censys.api.v3.host.v1+json"
          headers["X-Organization-ID"] = organization_id

          super(BASE_URL, headers: headers, pagination_interval: pagination_interval, timeout: timeout)
        end

        def search(query, size: nil, cursor: nil)
          params = {query: query, page_size: size, page_token: cursor}.compact
          Structs::Censys::V3::Response.from_dynamic! post_json("/v3/global/search/query", json: params)
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
end
