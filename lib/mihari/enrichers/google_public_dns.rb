# frozen_string_literal: true

module Mihari
  module Enrichers
    #
    # Google Public DNS enricher
    #
    class GooglePublicDNS < Base
      #
      # Query Google Public DNS
      #
      # @param [String] name
      #
      # @return [Array<Mihari::Structs::GooglePublicDNS::Response>]
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
      # @return [Mihari::Structs::GooglePublicDNS::Response, nil]
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

      class << self
        #
        # @return [String]
        #
        def class_key
          "google_public_dns"
        end
      end

      private

      def http
        HTTP::Factory.build timeout: timeout
      end
    end
  end
end
