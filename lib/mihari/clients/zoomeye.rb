# frozen_string_literal: true

module Mihari
  module Clients
    #
    # ZoomEye API client
    #
    class ZoomEye < Base
      PAGE_SIZE = 10

      attr_reader :api_key

      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [Hash] headers
      # @param [Integer] pagination_interval
      # @param [Integer, nil] timeout
      #
      def initialize(
        base_url = "https://api.zoomeye.org",
        api_key:,
        headers: {},
        pagination_interval: Mihari.config.pagination_interval,
        timeout: nil
      )
        raise(ArgumentError, "api_key is required") unless api_key

        headers["api-key"] = api_key
        super(base_url, headers:, pagination_interval:, timeout:)
      end

      #
      # @return [::HTTP::Client]
      #
      def http
        @http ||= HTTP::Factory.build(headers:, timeout:, raise_exception: false)
      end

      #
      # Search the Host devices
      #
      # @param [String] query Query string
      # @param [Integer, nil] page The page number to paging(default:1)
      # @param [String, nil] facets A comma-separated list of properties to get summary information on query
      #
      # @return [Hash]
      #
      def host_search(query, page: nil, facets: nil)
        params = {
          query:,
          page:,
          facets:
        }.compact
        get_json "/host/search", params:
      end

      #
      # @param [String] query
      # @param [String, nil] facets
      # @param [Integer] pagination_limit
      #
      # @return [Enumerable<Hash>]
      #
      def host_search_with_pagination(query, facets: nil, pagination_limit: Mihari.config.pagination_limit)
        Enumerator.new do |y|
          (1..pagination_limit).each do |page|
            res = host_search(query, facets:, page:)

            break if res.nil?

            y.yield res

            total = res["total"].to_i
            break if total <= page * PAGE_SIZE

            sleep_pagination_interval
          end
        end
      end

      #
      # Search the Web technologies
      #
      # @param [String] query Query string
      # @param [Integer, nil] page The page number to paging(default:1)
      # @param [String, nil] facets A comma-separated list of properties to get summary information on query
      #
      # @return [Hash]
      #
      def web_search(query, page: nil, facets: nil)
        params = {
          query:,
          page:,
          facets:
        }.compact
        get_json "/web/search", params:
      end

      #
      # @param [String] query
      # @param [String, nil] facets
      # @param [Integer] pagination_limit
      #
      # @return [Enumerable<Hash>]
      #
      def web_search_with_pagination(query, facets: nil, pagination_limit: Mihari.config.pagination_limit)
        Enumerator.new do |y|
          (1..pagination_limit).each do |page|
            res = web_search(query, facets:, page:)

            break if res.nil?

            y.yield res

            total = res["total"].to_i
            break if total <= page * PAGE_SIZE

            sleep_pagination_interval
          end
        end
      end
    end
  end
end
