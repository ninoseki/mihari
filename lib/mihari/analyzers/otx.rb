# frozen_string_literal: true

require "otx_ruby"

module Mihari
  module Analyzers
    class OTX < Base
      attr_reader :query
      attr_reader :type

      attr_reader :title
      attr_reader :description
      attr_reader :tags

      def initialize(query, title: nil, description: nil, tags: [])
        super()

        @query = query
        @type = TypeChecker.type(query)

        @title = title || "OTX lookup"
        @description = description || "query = #{query}"
        @tags = tags
      end

      def artifacts
        lookup || []
      end

      private

      def config_keys
        %w(otx_api_key)
      end

      def domain_client
        @domain_client ||= ::OTX::Domain.new(Mihari.config.otx_api_key)
      end

      def ip_client
        @ip_client ||= ::OTX::IP.new(Mihari.config.otx_api_key)
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
          raise InvalidInputError, "#{query}(type: #{type || 'unknown'}) is not supported." unless valid_type?
        end
      end

      def domain_lookup
        records = domain_client.get_passive_dns(query)
        records.map do |record|
          record.address if record.record_type == "A"
        end.compact.uniq
      end

      def ip_lookup
        records = ip_client.get_passive_dns(query)
        records.map do |record|
          record.hostname if record.record_type == "A"
        end.compact.uniq
      end
    end
  end
end
