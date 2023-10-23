# frozen_string_literal: true

module Mihari
  module Clients
    class OTX < Base
      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [Hash] headers
      # @param [Integer, nil] timeout
      #
      def initialize(base_url = "https://otx.alienvault.com", api_key:, headers: {}, timeout: nil)
        raise(ArgumentError, "api_key is required") unless api_key

        headers["x-otx-api-key"] = api_key
        super(base_url, headers: headers, timeout: timeout)
      end

      #
      # Domain search
      #
      # @param [String] query
      #
      # @return [Array<String>]
      #
      def domain_search(query)
        res = query_by_domain(query)
        return [] if res.nil?

        records = res["passive_dns"] || []
        records.filter_map do |record|
          record_type = record["record_type"]
          address = record["address"]

          address if record_type == "A"
        end.uniq
      end

      #
      # IP search
      #
      # @param [String] query
      #
      # @return [Array<String>]
      #
      def ip_search(query)
        res = query_by_ip(query)
        return [] if res.nil?

        records = res["passive_dns"] || []
        records.filter_map do |record|
          record_type = record["record_type"]
          hostname = record["hostname"]

          hostname if record_type == "A"
        end.uniq
      end

      #
      # @param [String] ip
      #
      # @return [Hash]
      #
      def query_by_ip(ip)
        _get "/api/v1/indicators/IPv4/#{ip}/passive_dns"
      end

      #
      # @param [String] domain
      #
      # @return [Hash]
      #
      def query_by_domain(domain)
        _get "/api/v1/indicators/domain/#{domain}/passive_dns"
      end

      private

      #
      # @param [String] path
      #
      # @return [Hash]
      #
      def _get(path)
        res = get(path)
        JSON.parse(res.body.to_s)
      end
    end
  end
end
