# frozen_string_literal: true

require "base64"

module Mihari
  module Clients
    class PassiveTotal < Base
      #
      # @param [String] base_url
      # @param [String, nil] username
      # @param [String, nil] api_key
      # @param [Hash] headers
      #
      def initialize(base_url = "https://api.passivetotal.org", username:, api_key:, headers: {})
        raise(ArgumentError, "'username' argument is required") if username.nil?
        raise(ArgumentError, "'api_key' argument is required") if api_key.nil?

        headers["authorization"] = "Basic #{Base64.strict_encode64("#{username}:#{api_key}")}"

        super(base_url, headers: headers)
      end

      #
      # @param [String] query
      #
      def ssl_search(query)
        params = { query: query }
        _get("/v2/ssl-certificate/history", params: params)
      end

      #
      # @param [String] query
      #
      # @return [Hash]
      #
      def passive_dns_search(query)
        params = { query: query }
        _get("/v2/dns/passive/unique", params: params)
      end

      #
      # @param [String] query the domain being queried
      # @param [String] field whether to return historical results
      #
      # @return [Hash]
      #
      def reverse_whois_search(query:, field:)
        params = {
          query: query,
          field: field
        }.compact
        _get("/v2/whois/search", params: params)
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
