# frozen_string_literal: true

module Mihari
  module Enrichers
    #
    # Shodan enricher
    #
    class Shodan < Base
      #
      # Query Shodan Internet DB
      #
      # @param [String] ip
      #
      # @return [Mihari::Structs::Shodan::InternetDBResponse, nil]
      #
      def call(ip)
        url = "https://internetdb.shodan.io/#{ip}"
        res = http.get(url)
        Structs::Shodan::InternetDBResponse.from_dynamic! JSON.parse(res.body.to_s)
      end
      memoize :call

      private

      def http
        HTTP::Factory.build timeout: timeout
      end
    end
  end
end
