# frozen_string_literal: true

require "virustotal"

module Mihari
  module Analyzers
    class VirusTotal < Base
      param :indicator
      option :title, default: proc { "VirusTotal lookup" }
      option :description, default: proc { "indicator = #{indicator}" }
      option :tags, default: proc { [] }

      attr_reader :type

      def initialize(*args, **kwargs)
        super

        @type = TypeChecker.type(indicator)
      end

      def artifacts
        lookup || []
      end

      private

      def config_keys
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
          raise InvalidInputError, "#{indicator}(type: #{type || "unknown"}) is not supported." unless valid_type?
        end
      end

      def domain_lookup
        res = api.domain.resolutions(indicator)

        data = res["data"] || []
        data.map do |item|
          item.dig("attributes", "ip_address")
        end.compact.uniq
      end

      def ip_lookup
        res = api.ip_address.resolutions(indicator)

        data = res["data"] || []
        data.map do |item|
          item.dig("attributes", "host_name")
        end.compact.uniq
      end
    end
  end
end
