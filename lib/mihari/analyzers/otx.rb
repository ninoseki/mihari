# frozen_string_literal: true

require "otx_ruby"

module Mihari
  module Analyzers
    class OTX < Base
      include Mixins::Refang

      param :query
      option :title, default: proc { "OTX search" }
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
        %w[otx_api_key]
      end

      def domain_client
        @domain_client ||= ::OTX::Domain.new(Mihari.config.otx_api_key)
      end

      def ip_client
        @ip_client ||= ::OTX::IP.new(Mihari.config.otx_api_key)
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
      # IP/domain search
      #
      # @return [Array<String>]
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
      # @return [Array<String>]
      #
      def domain_search
        records = domain_client.get_passive_dns(query)
        records.filter_map do |record|
          record.address if record.record_type == "A"
        end.uniq
      end

      #
      # IP search
      #
      # @return [Array<String>]
      #
      def ip_earch
        records = ip_client.get_passive_dns(query)
        records.filter_map do |record|
          record.hostname if record.record_type == "A"
        end.uniq
      end
    end
  end
end
