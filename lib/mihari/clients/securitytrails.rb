# frozen_string_literal: true

module Mihari
  module Clients
    class SecurityTrails < Base
      #
      # @param [String] base_url
      # @param [String, nil] api_key
      # @param [Hash] headers
      # @param [Integer, nil] timeout
      #
      def initialize(base_url = "https://api.securitytrails.com", api_key:, headers: {}, timeout: nil)
        raise(ArgumentError, "api_key is required") unless api_key

        headers["apikey"] = api_key

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
        records = get_all_dns_history(query, type: "a")
        records.map do |record|
          (record["values"] || []).map { |value| value["ip"] }
        end.flatten.compact.uniq
      end

      #
      # IP search
      #
      # @param [String] query
      #
      # @return [Array<Mihari::Artifact>]
      #
      def ip_search(query)
        records = search_by_ip(query)
        records.filter_map do |record|
          data = record["hostname"]
          Artifact.new(data: data, metadata: record)
        end
      end

      #
      # Mail search
      #
      # @param [String] query
      #
      # @return [Array<String>]
      #
      def mail_search(query)
        records = search_by_mail(query)
        records.filter_map do |record|
          data = record["hostname"]
          Artifact.new(data: data, metadata: record)
        end
      end

      #
      # @param [String] mail
      #
      # @return [Array<Hash>]
      #
      def search_by_mail(mail)
        res = _post "/v1/domains/list", json: { filter: { whois_email: mail } }
        res["records"] || []
      end

      #
      # @param [String] ip
      #
      # @return [Array<Hash>]
      #
      def search_by_ip(ip)
        res = _post "/v1/domains/list", json: { filter: { ipv4: ip } }
        res["records"] || []
      end

      #
      # @param [String] domain
      # @param [String] type
      #
      # @return [Array<Hash>]
      #
      def get_all_dns_history(domain, type:)
        first_page = get_dns_history(domain, type: type, page: 1)

        pages = first_page["pages"].to_i
        records = first_page["records"] || []

        (2..pages).each do |page_idx|
          next_page = get_dns_history(domain, type: type, page: page_idx)
          records << next_page["records"]
        end

        records.flatten
      end

      private

      #
      # @param [String] domain
      # @param [String] type
      # @param [Integer] page
      #
      # @return [Array<Hash>]
      #
      def get_dns_history(domain, type:, page:)
        _get "/v1/history/#{domain}/dns/#{type}", params: { page: page }
      end

      #
      # @param [String] path
      # @param [Hash, nil] params
      #
      # @return [Hash]
      #
      def _get(path, params:)
        res = get(path, params: params)
        JSON.parse(res.body.to_s)
      end

      #
      # @param [String] path
      # @param [Hash, nil] json
      #
      # @return [Hash]
      #
      def _post(path, json:)
        res = post(path, json: json)
        JSON.parse(res.body.to_s)
      end
    end
  end
end
