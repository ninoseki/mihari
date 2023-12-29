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
      # @return [Mihari::Structs::GooglePublicDNS::Response]
      #
      def call(name)
        client.query_all name
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

      def client
        Clients::GooglePublicDNS.new(timeout: timeout)
      end
    end
  end
end
