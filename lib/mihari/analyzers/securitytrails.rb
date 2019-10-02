# frozen_string_literal: true

require "securitytrails"

module Mihari
  module Analyzers
    class SecurityTrails < Base
      attr_reader :query
      attr_reader :type

      attr_reader :title
      attr_reader :description
      attr_reader :tags

      def initialize(query, title: nil, description: nil, tags: [])
        super()

        @query = query
        @type = TypeChecker.type(query)

        @title = title || "SecurityTrails lookup"
        @description = description || "query = #{query}"
        @tags = tags
      end

      def artifacts
        lookup || []
      end

      private

      def config_keys
        %w(SECURITYTRAILS_API_KEY)
      end

      def api
        @api ||= ::SecurityTrails::API.new
      end

      def valid_type?
        %w(ip domain mail).include? type
      end

      def lookup
        case type
        when "domain"
          domain_lookup
        when "ip"
          ip_lookup
        when "mail"
          mail_lookup
        else
          raise ArgumentError, "#{query}(type: #{type || 'unknown'}) is not supported." unless valid_type?
        end
      rescue ::SecurityTrails::Error => _e
        nil
      end

      def domain_lookup
        result = api.history.get_all_dns_history(query, "a")
        records = result.records || []
        records.map do |record|
          (record.values || []).map(&:ip)
        end.flatten.compact.uniq
      end

      def ip_lookup
        result = api.domains.search( filter: { ipv4: query })
        records = result.records || []
        records.map(&:hostname).compact.uniq
      end

      def mail_lookup
        result = api.domains.search( filter: { whois_email: query })
        records = result.records || []
        records.map(&:hostname).compact.uniq
      end
    end
  end
end
