# frozen_string_literal: true

require "securitytrails"

module Mihari
  module Analyzers
    class SecurityTrails < Base
      attr_reader :indicator
      attr_reader :type

      attr_reader :title
      attr_reader :description
      attr_reader :tags

      def initialize(indicator, title: nil, description: nil, tags: [])
        super()

        @indicator = indicator
        @type = TypeChecker.type(indicator)

        @title = title || "SecurityTrails lookup"
        @description = description || "indicator = #{indicator}"
        @tags = tags
      end

      def artifacts
        lookup || []
      end

      private

      def keys
        %w(SECURITYTRAILS_API_KEY)
      end

      def api
        @api ||= ::SecurityTrails::API.new
      end

      def valid_type?
        %w(ip domain).include? type
      end

      def lookup
        case type
        when "domain"
          domain_lookup
        when "ip"
          ip_lookup
        else
          raise ArgumentError, "#{indicator}(type: #{type || 'unknown'}) is not supported." unless valid_type?
        end
      rescue ::SecurityTrails::Error => _e
        nil
      end

      def domain_lookup
        result = api.history.get_all_dns_history(indicator, "a").to_h
        records = result.dig(:records) || []
        records.map do |record|
          values = record.dig(:values) || []
          values.map { |value| value.dig(:ip) }
        end.compact.flatten.uniq
      end

      def ip_lookup
        result = api.domains.search( filter: { ipv4: indicator }).to_h
        records = result.dig(:records) || []
        records.map do |record|
          record.dig(:hostname)
        end.compact.uniq
      end
    end
  end
end
