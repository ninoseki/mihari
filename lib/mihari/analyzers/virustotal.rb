# frozen_string_literal: true

require "virustotal"

module Mihari
  module Analyzers
    class VirusTotal < Base
      include Mixins::Refang

      param :query
      option :title, default: proc { "VirusTotal search" }
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
        %w[virustotal_api_key]
      end

      def api
        @api = ::VirusTotal::API.new(key: Mihari.config.virustotal_api_key)
      end

      #
      # Check whether a type is valid or not
      #
      # @return [Boolean]
      #
      def valid_type?
        %w[ip domain].include? type
      end

      #
      # Search
      #
      # @return [Array<Mihari::Artifact>]
      #
      def search
        case type
        when "domain"
          domain_search
        when "ip"
          ip_search
        else
          raise InvalidInputError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?
        end
      end

      #
      # Domain search
      #
      # @return [Array<Mihari::Artifact>]
      #
      def domain_search
        res = api.domain.resolutions(query)

        data = res["data"] || []
        data.filter_map do |item|
          data = item.dig("attributes", "ip_address")
          data.nil? ? nil : Artifact.new(data: data, source: source, metadata: item)
        end
      end

      #
      # IP search
      #
      # @return [Array<Mihari::Artifact>]
      #
      def ip_search
        res = api.ip_address.resolutions(query)

        data = res["data"] || []
        data.filter_map do |item|
          data = item.dig("attributes", "host_name")
          Artifact.new(data: data, source: source, metadata: item)
        end.uniq
      end
    end
  end
end
