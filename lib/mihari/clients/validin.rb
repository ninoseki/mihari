# frozen_string_literal: true

module Mihari
  module Clients
    #
    # Validin API client
    #
    class Validin < Base
      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [Hash] headers
      # @param [Integer, nil] timeout
      #
      def initialize(
        base_url = "https://app.validin.com",
        api_key:,
        headers: {},
        timeout: nil
      )
        raise(ArgumentError, "api_key is required") if api_key.nil?

        headers["Authorization"] = "Bearer #{api_key}"

        super(base_url, headers:, timeout:)
      end

      #
      # @param [String] domain
      #
      # @return [Hash]
      #
      def dns_history_search(domain)
        get_json "/api/axon/domain/dns/history/#{domain}/A"
      end

      #
      # @param [String] ip
      #
      # @return [Hash]
      #
      def search_reverse_ip(ip)
        get_json "/api/axon/ip/dns/history/#{ip}"
      end
    end
  end
end
