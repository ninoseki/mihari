# frozen_string_literal: true

module Mihari
  module Clients
    class DNSTwister < Base
      #
      # @param [String] base_url
      # @param [Hash] headers
      #
      def initialize(base_url = "https://dnstwister.report", headers: {})
        super(base_url, headers: headers)
      end

      #
      # Get fuzzy domains
      #
      # @param [String] domain
      #
      # @return [Hash]
      #
      def fuzz(domain)
        res = get("/api/fuzz/#{to_hex(domain)}")
        JSON.parse(res.body.to_s)
      end

      private

      #
      # Converts string to hex
      #
      # @param [String] str String
      #
      # @return [String] Hex
      #
      def to_hex(str)
        str.each_byte.map { |b| b.to_s(16) }.join
      end
    end
  end
end
