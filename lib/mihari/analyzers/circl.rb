# frozen_string_literal: true

require "passive_circl"

module Mihari
  module Analyzers
    class CIRCL < Base
      attr_reader :title
      attr_reader :description
      attr_reader :tags

      def initialize(query, title: nil, description: nil, tags: [])
        super()

        @query = query
        @type = TypeChecker.type(query)

        @title = title || "CIRCL passive lookup"
        @description = description || "query = #{query}"
        @tags = tags
      end

      def artifacts
        lookup || []
      end

      private

      def config_keys
        %w(CIRCL_PASSIVE_USERNAME CIRCL_PASSIVE_PASSWORD)
      end

      def api
        @api ||= ::PassiveCIRCL::API.new
      end

      def lookup
        case @type
        when "domain"
          passive_dns_lookup
        when "hash"
          passive_ssl_lookup
        else
          raise InvalidInputError, "#{@query}(type: #{@type || 'unknown'}) is not supported."
        end
      end

      def passive_dns_lookup
        results = api.dns.query(@query)
        results.map do |result|
          type = result.dig("rrtype")
          type == "A" ? result.dig("rdata") : nil
        end.compact.uniq
      end

      def passive_ssl_lookup
        result = api.ssl.cquery(@query)
        seen = result.dig("seen") || []
        seen.uniq
      end
    end
  end
end
