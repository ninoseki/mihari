# frozen_string_literal: true

module Mihari
  module Clients
    #
    # MMDB API client
    #
    class MMDB < Base
      #
      # @param [String] base_url
      # @param [Hash] headers
      # @param [Integer, nil] timeout
      #
      def initialize(base_url = "https://ip.circl.lu", headers: {}, timeout: nil)
        super(base_url, headers: headers, timeout: timeout)
      end

      #
      # @param [String] ip
      #
      # @return [Mihari::Structs::MMDB::Response]
      #
      def query(ip)
        Structs::MMDB::Response.from_dynamic! get_json("/geolookup/#{ip}")
      end
    end
  end
end
