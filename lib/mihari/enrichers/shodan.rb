# frozen_string_literal: true

require "net/https"

module Mihari
  module Enrichers
    class Shodan < Base
      include Memist::Memoizable

      #
      # Query Shodan Internet DB
      #
      # @param [String] ip
      #
      # @return [Mihari::Structs::Shodan::InternetDBResponse, nil]
      #
      def query(ip)
        url = "https://internetdb.shodan.io/#{ip}"
        res = http.get(url)
        data = JSON.parse(res.body.to_s)

        Structs::Shodan::InternetDBResponse.from_dynamic! data
      end
      memoize :query

      private

      def http
        HTTP::Factory.build timeout: timeout
      end
    end
  end
end
