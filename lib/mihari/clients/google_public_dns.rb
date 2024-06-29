# frozen_string_literal: true

module Mihari
  module Clients
    #
    # Google Public DNS enricher
    #
    class GooglePublicDNS < Base
      #
      # @param [String] base_url
      # @param [Hash] headers
      # @param [Integer, nil] timeout
      #
      def initialize(base_url = "https://dns.google", headers: {}, timeout: nil)
        super
      end

      #
      # Query Google Public DNS by resource type
      #
      # @param [String] name
      #
      # @return [Mihari::Structs::GooglePublicDNS::Response, nil]
      #
      def query_all(name)
        Structs::GooglePublicDNS::Response.from_dynamic! get_json("/resolve",
          params: {name:, type: "ALL"})
      end
    end
  end
end
