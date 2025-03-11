# frozen_string_literal: true

require "base64"

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
        base_url = "https://api.zoomeye.ai",
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
      # Search
      #
      # @param [String] query Query string
      # @param [Integer, nil] page The page number to paging(default:1)
      #
      # @return [Structs::ZoomEye::Response]
      #
      # @param [Object, nil] facets
      def search(query, page: nil)
        qbase64 = Base64.urlsafe_encode64(query)
        json = {qbase64:, page:}.compact
        Structs::ZoomEye::Response.from_dynamic! post_json("/v2/search", json:)
      end

      #
      # @param [String] query
      # @param [Integer] pagination_limit
      #
      # @return [Enumerable<Structs::ZoomEye::Response>]
      #
      def search_with_pagination(query, pagination_limit: Mihari.config.pagination_limit)
        Enumerator.new do |y|
          (1..pagination_limit).each do |page|
            res = search(query, page:)

            break if res.nil?

            y.yield res

            break if res.total <= page * PAGE_SIZE

            sleep_pagination_interval
          end
        end
      end
    end
  end
end
