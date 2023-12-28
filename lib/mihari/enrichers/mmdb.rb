# frozen_string_literal: true

module Mihari
  module Enrichers
    #
    # MMDB enricher
    #
    class MMDB < Base
      #
      # Query MMDB
      #
      # @param [String] ip
      #
      # @return [Mihari::Structs::MMDB::Response]
      #
      def call(ip)
        url = "https://ip.circl.lu/geolookup/#{ip}"
        res = http.get(url)
        Structs::MMDB::Response.from_dynamic! JSON.parse(res.body.to_s)
      end
      memo_wise :call

      private

      #
      # @return [Mihari::HTTP]
      #
      def http
        HTTP::Factory.build timeout: timeout
      end
    end
  end
end
