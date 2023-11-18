# frozen_string_literal: true

module Mihari
  module Enrichers
    #
    # IPInfo enricher
    #
    class IPInfo < Base
      # @return [String, nil]
      attr_reader :api_key

      #
      # @param [Hash, nil] options
      # @param [String, nil] api_key
      #
      def initialize(options: nil, api_key: nil)
        @api_key = api_key || Mihari.config.ipinfo_api_key

        super(options: options)
      end

      def configuration_keys
        %w[ipinfo_api_key]
      end

      #
      # Query IPInfo
      #
      # @param [String] ip
      #
      # @return [Mihari::Structs::IPInfo::Response]
      #
      def call(ip)
        url = "https://ipinfo.io/#{ip}/json"
        res = http.get(url)
        Structs::IPInfo::Response.from_dynamic! JSON.parse(res.body.to_s)
      end

      private

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
