# frozen_string_literal: true

require "base64"

module Mihari
  module Clients
    class Censys < Base
      #
      # @param [String] base_url
      # @param [String, nil] id
      # @param [String, nil] secret
      # @param [Hash] headers
      # @param [Integer, nil] interval
      # @param [Integer, nil] timeout
      #
      def initialize(base_url = "https://search.censys.io", id:, secret:, headers: {}, interval: nil, timeout: nil)
        raise(ArgumentError, "'id' argument is required") if id.nil?
        raise(ArgumentError, "'secret' argument is required") if secret.nil?

        headers["authorization"] = "Basic #{Base64.strict_encode64("#{id}:#{secret}")}"

        super(base_url, headers: headers, interval: interval, timeout: timeout)
      end

      #
      # Search current index.
      #
      # Searches the given index for all records that match the given query.
      # For more details, see our documentation: https://search.censys.io/api/v2/docs
      #
      # @param [String] query the query to be executed.
      # @params [Integer, nil] per_page the number of results to be returned for each page.
      # @params [Integer, nil] cursor the cursor of the desired result set.
      #
      # @return [Structs::Censys::Response]
      #
      def search(query, per_page: nil, cursor: nil)
        params = { q: query, per_page: per_page, cursor: cursor }.compact
        res = get("/api/v2/hosts/search", params: params)
        Structs::Censys::Response.from_dynamic! JSON.parse(res.body.to_s)
      end

      #
      # @param [String] query
      # @param [Integer, nil] per_page
      # @param [Integer] pagination_limit
      #
      # @return [Enumerable<Structs::Censys::Response>]
      #
      def search_with_pagination(query, per_page: nil, pagination_limit: Mihari.config.pagination_limit)
        cursor = nil

        Enumerator.new do |y|
          pagination_limit.times do
            res = search(query, per_page: per_page, cursor: cursor)

            y.yield res

            cursor = res.result.links.next
            # NOTE: Censys's search API is unstable recently
            # it may returns empty links or empty string cursors
            # - Empty links: "links": {}
            # - Empty cursors: "links": { "next": "", "prev": "" }
            # So it needs to check both cases
            break if cursor.nil? || cursor.empty?

            sleep_interval
          end
        end
      end
    end
  end
end
