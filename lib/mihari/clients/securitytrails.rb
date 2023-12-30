# frozen_string_literal: true

module Mihari
  module Clients
    #
    # SecurityTrails API client
    #
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
      # IP search
      #
      # @param [String] query
      #
      # @return [Hash]
      #
      def ip_search(query)
        search_by_ip(query)
      end

      #
      # Mail search
      #
      # @param [String] query
      #
      # @return [Hash]
      #
      def mail_search(query)
        search_by_mail(query)
      end

      #
      # @param [String] mail
      #
      # @return [Hash]
      #
      def search_by_mail(mail)
        post_json "/v1/domains/list", json: { filter: { whois_email: mail } }
      end

      #
      # @param [String] ip
      #
      # @return [Hash]
      #
      def search_by_ip(ip)
        post_json "/v1/domains/list", json: { filter: { ipv4: ip } }
      end

      #
      # @param [String] domain
      # @param [String] type
      # @param [Integer] page
      #
      # @return [Enumerable<Hash>]
      #
      def get_all_dns_history(domain, type:, page: 1)
        Enumerator.new do |y|
          res = get_dns_history(domain, type: type, page: page)
          y.yield res

          pages = res["pages"].to_i

          (page + 1..pages).each do |page|
            y.yield get_dns_history(domain, type: type, page: page)
          end
        end
      end

      private

      #
      # @param [String] domain
      # @param [String] type
      # @param [Integer] page
      #
      # @return [Hash]
      #
      def get_dns_history(domain, type:, page:)
        get_json "/v1/history/#{domain}/dns/#{type}", params: { page: page }
      end
    end
  end
end
