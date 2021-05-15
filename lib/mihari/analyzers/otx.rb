# frozen_string_literal: true

require "otx_ruby"

module Mihari
  module Analyzers
    class OTX < Base
      param :query
      option :title, default: proc { "OTX lookup" }
      option :description, default: proc { "query = #{query}" }
      option :tags, default: proc { [] }

      attr_reader :type

      def initialize(*args, **kwargs)
        super

        @type = TypeChecker.type(query)
      end

      def artifacts
        lookup || []
      end

      private

      def config_keys
        %w[otx_api_key]
      end

      def domain_client
        @domain_client ||= ::OTX::Domain.new(Mihari.config.otx_api_key)
      end

      def ip_client
        @ip_client ||= ::OTX::IP.new(Mihari.config.otx_api_key)
      end

      def valid_type?
        %w[ip domain].include? type
      end

      def lookup
        case type
        when "domain"
          domain_lookup
        when "ip"
          ip_lookup
        else
          raise InvalidInputError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?
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
