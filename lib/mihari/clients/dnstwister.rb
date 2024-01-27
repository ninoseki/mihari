# frozen_string_literal: true

module Mihari
  module Clients
    #
    # DNSTwister API client
    #
    class DNSTwister < Base
      #
      # @param [String] base_url
      # @param [Hash] headers
      # @param [Integer, nil] timeout
      #
      def initialize(base_url = "https://dnstwister.report", headers: {}, timeout: nil)
        super(base_url, headers:, timeout:)
      end

      #
      # Get fuzzy domains
      #
      # @param [String] domain
      #
      # @return [Array<String>]
      #
      def fuzz(domain)
        res = get_json("/api/fuzz/#{to_hex(domain)}")
        fuzzy_domains = res["fuzzy_domains"] || []
        fuzzy_domains.map { |d| d["domain"] }
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
