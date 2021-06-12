# frozen_string_literal: true

require "passive_circl"

module Mihari
  module Analyzers
    class CIRCL < Base
      include Mixins::Refang

      param :query
      option :title, default: proc { "CIRCL passive lookup" }
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

      def configuration_keys
        %w[circl_passive_password circl_passive_username]
      end

      def api
        @api ||= ::PassiveCIRCL::API.new(username: Mihari.config.circl_passive_username, password: Mihari.config.circl_passive_password)
      end

      def lookup
        case @type
        when "domain"
          passive_dns_lookup
        when "hash"
          passive_ssl_lookup
        else
          raise InvalidInputError, "#{@query}(type: #{@type || "unknown"}) is not supported."
        end
      end

      def passive_dns_lookup
        results = api.dns.query(@query)
        results.filter_map do |result|
          type = result["rrtype"]
          type == "A" ? result["rdata"] : nil
        end.uniq
      end

      def passive_ssl_lookup
        result = api.ssl.cquery(@query)
        seen = result["seen"] || []
        seen.uniq
      end
    end
  end
end
