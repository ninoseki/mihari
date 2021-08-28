# frozen_string_literal: true

require "passivetotal"

module Mihari
  module Analyzers
    class PassiveTotal < Base
      include Mixins::Refang

      param :query
      option :title, default: proc { "PassiveTotal search" }
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
        %w[passivetotal_username passivetotal_api_key]
      end

      def api
        @api ||= ::PassiveTotal::API.new(username: Mihari.config.passivetotal_username, api_key: Mihari.config.passivetotal_api_key)
      end

      #
      # Check whether a type is valid or not
      #
      # @return [Boolean]
      #
      def valid_type?
        %w[ip domain mail hash].include? type
      end

      #
      # Passive DNS/SSL, reverse whois search
      #
      # @return [Array<String>]
      #
      def search
        case type
        when "domain", "ip"
          passive_dns_search
        when "mail"
          reverse_whois_search
        when "hash"
          ssl_search
        else
          raise InvalidInputError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?
        end
      end

      #
      # Passive DNS search
      #
      # @return [Array<String>]
      #
      def passive_dns_search
        res = api.dns.passive_unique(query)
        res["results"] || []
      end

      #
      # Reverse whois search
      #
      # @return [Array<String>]
      #
      def reverse_whois_search
        res = api.whois.search(query: query, field: "email")
        results = res["results"] || []
        results.map do |result|
          result["domain"]
        end.flatten.compact.uniq
      end

      #
      # Passive SSL search
      #
      # @return [Array<String>]
      #
      def ssl_search
        res = api.ssl.history(query)
        results = res["results"] || []
        results.map do |result|
          result["ipAddresses"]
        end.flatten.compact.uniq
      end
    end
  end
end
