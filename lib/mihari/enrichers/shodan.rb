# frozen_string_literal: true

require "net/https"

module Mihari
  module Enrichers
    class Shodan < Base
      # @return [Boolean]
      def valid?
        true
      end

      class << self
        include Dry::Monads[:result]
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
          res = HTTP::Factory.build.get(url)
          data = JSON.parse(res.body.to_s)

          Structs::Shodan::InternetDBResponse.from_dynamic! data
        end
        memoize :query
      end
    end
  end
end
