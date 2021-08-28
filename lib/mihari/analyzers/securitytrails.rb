# frozen_string_literal: true

require "securitytrails"

module Mihari
  module Analyzers
    class SecurityTrails < Base
      include Mixins::Refang

      param :query
      option :title, default: proc { "SecurityTrails search" }
      option :description, default: proc { "query = #{query}" }
      option :tags, default: proc { [] }

      attr_reader :type

      def initialize(*args, **kwargs)
        super

        @query = refang(query)
        @type = TypeChecker.type(query)
      end

      def artifacts
        search || []
      end

      private

      def configuration_keys
        %w[securitytrails_api_key]
      end

      def api
        @api ||= ::SecurityTrails::API.new(Mihari.config.securitytrails_api_key)
      end

      #
      # Check whether a type is valid or not
      #
      # @return [Boolean]
      #
      def valid_type?
        %w[ip domain mail].include? type
      end

      #
      # IP/domain/mail search
      #
      # @return [Array<String>]
      #
      def search
        case type
        when "domain"
          domain_search
        when "ip"
          ip_search
        when "mail"
          mail_search
        else
          raise InvalidInputError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?
        end
      end

      #
      # Domain search
      #
      # @return [Array<String>]
      #
      def domain_search
        result = api.history.get_all_dns_history(query, type: "a")
        records = result["records"] || []
        records.map do |record|
          (record["values"] || []).map { |value| value["ip"] }
        end.flatten.compact.uniq
      end

      #
      # IP search
      #
      # @return [Array<String>]
      #
      def ip_search
        result = api.domains.search(filter: { ipv4: query })
        records = result["records"] || []
        records.filter_map { |record| record["hostname"] }.uniq
      end

      #
      # Mail search
      #
      # @return [Array<String>]
      #
      def mail_search
        result = api.domains.search(filter: { whois_email: query })
        records = result["records"] || []
        records.filter_map { |record| record["hostname"] }.uniq
      end
    end
  end
end
