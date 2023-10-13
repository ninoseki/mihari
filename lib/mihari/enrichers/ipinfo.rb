# frozen_string_literal: true

require "net/https"

module Mihari
  module Enrichers
    class IPInfo < Base
      # @return [Boolean]
      def valid?
        Mihari.config.ipinfo_api_key.nil?
      end

      private

      def configuration_keys
        %w[ipinfo_api_key]
      end

      class << self
        include Dry::Monads[:result]
        include Memist::Memoizable

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

        private

        def headers
          token = Mihari.config.ipinfo_api_key
          authorization = token.nil? ? nil : "Bearer #{token}"
          { authorization: authorization }.compact
        end

        def http
          HTTP::Factory.build headers: headers
        end
      end
    end
  end
end
