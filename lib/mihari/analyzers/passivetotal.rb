# frozen_string_literal: true

require "passivetotal"

module Mihari
  module Analyzers
    class PassiveTotal < Base
      attr_reader :query
      attr_reader :type

      attr_reader :title
      attr_reader :description
      attr_reader :tags

      def initialize(query, title: nil, description: nil, tags: [])
        super()

        @query = query
        @type = TypeChecker.type(query)

        @title = title || "PassiveTotal lookup"
        @description = description || "query = #{query}"
        @tags = tags
      end

      def artifacts
        lookup || []
      end

      private

      def config_keys
        %w(PASSIVETOTAL_USERNAME PASSIVETOTAL_API_KEY)
      end

      def api
        @api ||= ::PassiveTotal::API.new
      end

      def valid_type?
        %w(ip domain mail).include? type
      end

      def lookup
        case type
        when "domain"
          passive_dns_lookup
        when "ip"
          passive_dns_lookup
        when "mail"
          reverse_whois_lookup
        when "hash"
          ssl_lookup
        else
          raise TypeError, "#{query}(type: #{type || 'unknown'}) is not supported." unless valid_type?
        end
      rescue ::PassiveTotal::Error => _e
        nil
      end

      def passive_dns_lookup
        res = api.dns.passive_unique(query)
        res.dig("results") || []
      end

      def reverse_whois_lookup
        res = api.whois.search(query: query, field: "email")
        results = res.dig("results") || []
        results.map do |result|
          result.dig("domain")
        end.flatten.compact.uniq
      end

      def ssl_lookup
        res = api.ssl.history(query)
        results = res.dig("results") || []
        results.map do |result|
          result.dig("ipAddresses")
        end.flatten.compact.uniq
      end
    end
  end
end
