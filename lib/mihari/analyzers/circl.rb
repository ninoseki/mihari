# frozen_string_literal: true

require "passive_circl"

module Mihari
  module Analyzers
    class CIRCL < Base
      include Mixins::Refang

      param :query
      option :title, default: proc { "CIRCL passive DNS/SSL search" }
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
        %w[circl_passive_password circl_passive_username]
      end

      def api
        @api ||= ::PassiveCIRCL::API.new(username: Mihari.config.circl_passive_username, password: Mihari.config.circl_passive_password)
      end

      #
      # Passive DNS/SSL search
      #
      # @return [Array<String>]
      #
      def search
        case @type
        when "domain"
          passive_dns_search
        when "hash"
          passive_ssl_search
        else
          raise InvalidInputError, "#{@query}(type: #{@type || "unknown"}) is not supported."
        end
      end

      #
      # Passive DNS search
      #
      # @return [Array<String>]
      #
      def passive_dns_search
        results = api.dns.query(@query)
        results.filter_map do |result|
          type = result["rrtype"]
          type == "A" ? result["rdata"] : nil
        end.uniq
      end

      #
      # Passive SSL search
      #
      # @return [Array<String>]
      #
      def passive_ssl_search
        result = api.ssl.cquery(@query)
        seen = result["seen"] || []
        seen.uniq
      end
    end
  end
end
