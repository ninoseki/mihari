# frozen_string_literal: true

require "passivetotal"

module Mihari
  module Analyzers
    class PassiveTotal < Base
      include Mixins::Utils

      param :query
      option :title, default: proc { "PassiveTotal lookup" }
      option :description, default: proc { "query = #{query}" }
      option :tags, default: proc { [] }

      attr_reader :type

      def initialize(*args, **kwargs)
        super

        @query = refang(query)
        @type = TypeChecker.type(query)
      end

      def artifacts
        lookup || []
      end

      private

      def config_keys
        %w[passivetotal_username passivetotal_api_key]
      end

      def api
        @api ||= ::PassiveTotal::API.new(username: Mihari.config.passivetotal_username, api_key: Mihari.config.passivetotal_api_key)
      end

      def valid_type?
        %w[ip domain mail].include? type
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
          raise InvalidInputError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?
        end
      end

      def passive_dns_lookup
        res = api.dns.passive_unique(query)
        res["results"] || []
      end

      def reverse_whois_lookup
        res = api.whois.search(query: query, field: "email")
        results = res["results"] || []
        results.map do |result|
          result["domain"]
        end.flatten.compact.uniq
      end

      def ssl_lookup
        res = api.ssl.history(query)
        results = res["results"] || []
        results.map do |result|
          result["ipAddresses"]
        end.flatten.compact.uniq
      end
    end
  end
end
