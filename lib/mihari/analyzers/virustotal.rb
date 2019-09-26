# frozen_string_literal: true

require "virustotal"

module Mihari
  module Analyzers
    class VirusTotal < Base
      attr_reader :indicator
      attr_reader :type

      attr_reader :title
      attr_reader :description
      attr_reader :tags

      def initialize(indicator, title: nil, description: nil, tags: [])
        super()

        @indicator = indicator
        @type = TypeChecker.type(indicator)

        @title = title || "VirusTotal lookup"
        @description = description || "indicator = #{indicator}"
        @tags = tags
      end

      def artifacts
        lookup || []
      end

      private

      def api
        @api = ::VirusTotal::API.new
      end

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
        begin
          res = api.domain.resolutions(indicator)
        rescue ::VirusTotal::Error => _e
          return nil
        end

        data = res.dig("data") || []
        data.map do |item|
          item.dig("attributes", "ip_address")
        end.compact.uniq
      end

      def ip_lookup
        begin
          res = api.ip_address.resolutions(indicator)
        rescue ::VirusTotal::Error => _e
          return nil
        end

        data = res.dig("data") || []
        data.map do |item|
          item.dig("attributes", "host_name")
        end.compact.uniq
      end
    end
  end
end
