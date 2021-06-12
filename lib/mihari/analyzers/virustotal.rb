# frozen_string_literal: true

require "virustotal"

module Mihari
  module Analyzers
    class VirusTotal < Base
      include Mixins::Refang

      param :query
      option :title, default: proc { "VirusTotal lookup" }
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
        %w[virustotal_api_key]
      end

      def api
        @api = ::VirusTotal::API.new(key: Mihari.config.virustotal_api_key)
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
        res = api.domain.resolutions(query)

        data = res["data"] || []
        data.filter_map do |item|
          item.dig("attributes", "ip_address")
        end.uniq
      end

      def ip_lookup
        res = api.ip_address.resolutions(query)

        data = res["data"] || []
        data.filter_map do |item|
          item.dig("attributes", "host_name")
        end.uniq
      end
    end
  end
end
