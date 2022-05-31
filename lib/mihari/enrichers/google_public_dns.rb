# frozen_string_literal: true

require "net/https"

module Mihari
  module Enrichers
    class GooglePublicDNS < Base
      # @return [Boolean]
      def valid?
        true
      end

      class << self
        #
        # Query Google Public DNS
        #
        # @param [String] name
        # @param [String] resource_type
        #
        # @return [Mihari::Structs::Shodan::GooglePublicDNS::Response, nil]
        #
        def query(name, resource_type)
          url = "https://dns.google/resolve"
          params = { name: name, type: resource_type }
          res = HTTP.get(url, params: params)

          data = JSON.parse(res.body.to_s)

          Structs::GooglePublicDNS::Response.from_dynamic! data
        rescue HTTPError
          nil
        end
      end
    end
  end
end
