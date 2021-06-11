# frozen_string_literal: true

require "securitytrails"

module Mihari
  module Analyzers
    class SecurityTrails < Base
      include Mixins::Utils

      param :query
      option :title, default: proc { "SecurityTrails lookup" }
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
        %w[securitytrails_api_key]
      end

      def api
        @api ||= ::SecurityTrails::API.new(Mihari.config.securitytrails_api_key)
      end

      def valid_type?
        %w[ip domain mail].include? type
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
          raise InvalidInputError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?
        end
      end

      def domain_lookup
        result = api.history.get_all_dns_history(query, type: "a")
        records = result["records"] || []
        records.map do |record|
          (record["values"] || []).map { |value| value["ip"] }
        end.flatten.compact.uniq
      end

      def ip_lookup
        result = api.domains.search(filter: { ipv4: query })
        records = result["records"] || []
        records.filter_map { |record| record["hostname"] }.uniq
      end

      def mail_lookup
        result = api.domains.search(filter: { whois_email: query })
        records = result["records"] || []
        records.filter_map { |record| record["hostname"] }.uniq
      end
    end
  end
end
