# frozen_string_literal: true

require "virustotal"

module Mihari
  module Analyzers
    class VirusTotal < Base
      attr_reader :api
      attr_reader :indicator
      attr_reader :type

      attr_reader :title
      attr_reader :description
      attr_reader :tags

      def initialize(indicator, tags: [])
        super()

        @api = ::VirusTotal::API.new
        @indicator = indicator
        @type = TypeChecker.type(indicator)

        @title = "VirusTotal lookup"
        @description = "indicator = #{indicator}"
        @tags = tags
      end

      def artifacts
        lookup || []
      end

      private

      def valid_type?
        %w(ip domain).include? type
      end

      def lookup
        case type
        when "domain"
          domain_lookup
        when "ip"
          ip_lookup
        else
          raise ArgumentError, "#{indicator}(type: #{type || 'unknown'}) is not supported." unless valid_type?
        end
      rescue ::VirusTotal::Error => _e
        nil
      end

      def domain_lookup
        report = api.domain.report(indicator)
        return nil unless report

        resolutions = report.dig("resolutions") || []
        resolutions.map do |resolution|
          resolution.dig("ip_address")
        end.compact.uniq
      end

      def ip_lookup
        report = api.ip_address.report(indicator)
        return nil unless report

        resolutions = report.dig("resolutions") || []
        resolutions.map do |resolution|
          resolution.dig("hostname")
        end.compact.uniq
      end
    end
  end
end
