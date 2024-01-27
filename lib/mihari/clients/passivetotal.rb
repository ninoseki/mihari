# frozen_string_literal: true

require "base64"

module Mihari
  module Clients
    #
    # PassiveTotal API client
    #
    class PassiveTotal < Base
      #
      # @param [String] base_url
      # @param [String, nil] username
      # @param [String, nil] api_key
      # @param [Hash] headers
      # @param [Integer, nil] timeout
      #
      def initialize(base_url = "https://api.passivetotal.org", username:, api_key:, headers: {}, timeout: nil)
        raise(ArgumentError, "username is required") if username.nil?
        raise(ArgumentError, "api_key is required") if api_key.nil?

        headers["authorization"] = "Basic #{Base64.strict_encode64("#{username}:#{api_key}")}"

        super(base_url, headers:, timeout:)
      end

      #
      # Passive DNS search
      #
      # @param [String] query
      #
      # @return [Hash]
      #
      def passive_dns_search(query)
        params = {query:}
        get_json("/v2/dns/passive/unique", params:)
      end

      #
      # Reverse whois search
      #
      # @param [String] query
      #
      # @return [Hash]
      #
      def reverse_whois_search(query)
        get_json("/v2/whois/search", params: {
          query:,
          field: "email"
        }.compact)
      end

      #
      # Passive SSL search
      #
      # @param [String] query
      #
      # @return [Hash]
      #
      def ssl_search(query)
        get_json("/v2/ssl-certificate/history", params: {query:})
      end
    end
  end
end
