# frozen_string_literal: true

module Mihari
  module Clients
    #
    # Shodan Internet DB API client
    #
    class ShodanInternetDB < Base
      #
      # @param [String] base_url
      # @param [Hash] headers
      # @param [Integer, nil] timeout
      #
      def initialize(base_url = "https://internetdb.shodan.io", headers: {}, timeout: nil)
        super
      end

      #
      # @param [String] ip
      #
      # @return [Mihari::Structs::Shodan::InternetDBResponse]
      #
      def query(ip)
        Structs::Shodan::InternetDBResponse.from_dynamic! get_json("/#{ip}")
      end
    end
  end
end
