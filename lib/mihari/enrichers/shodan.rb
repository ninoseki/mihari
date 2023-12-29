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
        client.query ip
      end
      memo_wise :call

      private

      def client
        @client ||= Clients::ShodanInternetDB.new(timeout: timeout)
      end
    end
  end
end
