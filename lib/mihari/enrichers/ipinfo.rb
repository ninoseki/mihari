require "http"
require "json"
require "memist"

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
        include Memist::Memoizable

        #
        # Query IPInfo
        #
        # @param [String] ip
        #
        # @return [Mihari::Structs::IPInfo::Response, nil]
        #
        def query(ip)
          headers = {}
          token = Mihari.config.ipinfo_api_key
          unless token.nil?
            headers[:authorization] = "Bearer #{token}"
          end

          begin
            res = HTTP.headers(headers).get("https://ipinfo.io/#{ip}/json")
            data = JSON.parse(res.body.to_s)

            Structs::IPInfo::Response.from_dynamic! data
          rescue HTTP::Error
            nil
          end
        end
        memoize :query
      end
    end
  end
end
