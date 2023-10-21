# frozen_string_literal: true

require "net/https"

module Mihari
  module Enrichers
    class IPInfo < Base
      include Memist::Memoizable

      # @return [String, nil]
      attr_reader :api_key

      def initialize(options: nil, api_key: nil)
        @api_key = api_key || Mihari.config.ipinfo_api_key

        super(options: options)
      end

      private

      def configuration_keys
        %w[ipinfo_api_key]
      end

      #
      # Query IPInfo
      #
      # @param [String] ip
      #
      # @return [Mihari::Structs::IPInfo::Response, nil]
      #
      def query(ip)
        url = "https://ipinfo.io/#{ip}/json"
        res = http.get(url)
        data = JSON.parse(res.body.to_s)

        Structs::IPInfo::Response.from_dynamic! data
      end
      memoize :query

      def headers
        authorization = api_key.nil? ? nil : "Bearer #{api_key}"
        { authorization: authorization }.compact
      end

      def http
        HTTP::Factory.build headers: headers, timeout: timeout
      end
    end
  end
end
