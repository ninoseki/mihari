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
      # @param [Integer, nil] timeout
      #
      def initialize(base_url = "https://api.passivetotal.org", username:, api_key:, headers: {}, timeout: nil)
        raise(ArgumentError, "username is required") if username.nil?
        raise(ArgumentError, "api_key is required") if api_key.nil?

        headers["authorization"] = "Basic #{Base64.strict_encode64("#{username}:#{api_key}")}"

        super(base_url, headers: headers, timeout: timeout)
      end

      #
      # Passive DNS search
      #
      # @param [String] query
      #
      # @return [Array<String>]
      #
      def passive_dns_search(query)
        params = { query: query }
        res = _get("/v2/dns/passive/unique", params: params)
        res["results"] || []
      end

      #
      # Reverse whois search
      #
      # @param [String] query
      #
      # @return [Array<Mihari::Models::Artifact>]
      #
      def reverse_whois_search(query)
        params = {
          query: query,
          field: "email"
        }.compact
        res = _get("/v2/whois/search", params: params)
        results = res["results"] || []
        results.map do |result|
          data = result["domain"]
          Models::Artifact.new(data: data, metadata: result)
        end.flatten
      end

      #
      # Passive SSL search
      #
      # @param [String] query
      #
      # @return [Array<Mihari::Models::Artifact>]
      #
      def ssl_search(query)
        params = { query: query }
        res = _get("/v2/ssl-certificate/history", params: params)
        results = res["results"] || []
        results.map do |result|
          data = result["ipAddresses"]
          data.map { |d| Models::Artifact.new(data: d, metadata: result) }
        end.flatten
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
