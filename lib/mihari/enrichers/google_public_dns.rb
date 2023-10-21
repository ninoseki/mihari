# frozen_string_literal: true

require "net/https"

module Mihari
  module Enrichers
    class GooglePublicDNS < Base
      #
      # Query Google Public DNS
      #
      # @param [String] name
      #
      # @return [Array<Mihari::Structs::Shodan::GooglePublicDNS::Response>]
      #
      def query(name)
        %w[A AAAA CNAME TXT NS].filter_map do |resource_type|
          query_by_type(name, resource_type)
        end
      end

      #
      # Query Google Public DNS by resource type
      #
      # @param [String] name
      # @param [String] resource_type
      #
      # @return [Mihari::Structs::Shodan::GooglePublicDNS::Response, nil]
      #
      def query_by_type(name, resource_type)
        url = "https://dns.google/resolve"
        params = { name: name, type: resource_type }
        res = http.get(url, params: params)

        data = JSON.parse(res.body.to_s)

        Structs::GooglePublicDNS::Response.from_dynamic! data
      rescue HTTPError
        nil
      end

      private

      def http
        HTTP::Factory.build timeout: timeout
      end
    end
  end
end
