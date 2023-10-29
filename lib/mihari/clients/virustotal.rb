# frozen_string_literal: true

module Mihari
  module Clients
    #
    # VirusTotal API client
    #
    class VirusTotal < Base
      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [Hash] headers
      # @param [Integer] pagination_interval
      # @param [Integer, nil] timeout
      #
      def initialize(
        base_url = "https://www.virustotal.com",
        api_key:,
        headers: {},
        pagination_interval: Mihari.config.pagination_interval,
        timeout: nil
      )
        raise(ArgumentError, "api_key is required") if api_key.nil?

        headers["x-apikey"] = api_key

        super(base_url, headers: headers, pagination_interval: pagination_interval, timeout: timeout)
      end

      #
      # @param [String] query
      #
      # @return [Hash]
      #
      def domain_search(query)
        _get("/api/v3/domains/#{query}/resolutions")
      end

      #
      # @param [String] query
      #
      # @return [Hash]
      #
      def ip_search(query)
        _get("/api/v3/ip_addresses/#{query}/resolutions")
      end

      #
      # @param [String] query
      # @param [String, nil] cursor
      #
      # @return [Structs::VirusTotalIntelligence::Response]
      #
      def intel_search(query, cursor: nil)
        params = { query: query, cursor: cursor }.compact
        res = _get("/api/v3/intelligence/search", params: params)
        Structs::VirusTotalIntelligence::Response.from_dynamic! res
      end

      #
      # @param [String] query
      # @param [Integer] pagination_limit
      #
      # @return [Enumerable<Structs::VirusTotalIntelligence::Response>]
      #
      def intel_search_with_pagination(query, pagination_limit: Mihari.config.pagination_limit)
        cursor = nil

        Enumerator.new do |y|
          pagination_limit.times do
            res = intel_search(query, cursor: cursor)

            y.yield res

            cursor = res.meta.cursor
            break if cursor.nil?

            sleep_pagination_interval
          end
        end
      end

      private

      #
      # @param [String] path
      # @param [Hash] params
      #
      # @return [Hash]
      #
      def _get(path, params: {})
        res = get(path, params: params)
        JSON.parse(res.body.to_s)
      end
    end
  end
end
