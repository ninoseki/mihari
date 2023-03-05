# frozen_string_literal: true

module Mihari
  module Analyzers
    class OTX < Base
      include Mixins::Refang

      param :query

      # @return [String, nil]
      attr_reader :type

      # @return [String, nil]
      attr_reader :api_key

      def initialize(*args, **kwargs)
        super

        @query = refang(query)
        @type = TypeChecker.type(query)

        @api_key = kwargs[:api_key] || Mihari.config.otx_api_key
      end

      def artifacts
        search || []
      end

      private

      def configuration_keys
        %w[otx_api_key]
      end

      def client
        @client ||= Mihari::Clients::OTX.new(headers: { "x-otx-api-key": api_key })
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
        res = client.query_by_domain(query)
        return [] if res.nil?

        records = res["passive_dns"] || []
        records.filter_map do |record|
          record_type = record["record_type"]
          address = record["address"]

          address if record_type == "A"
        end.uniq
      end

      #
      # IP search
      #
      # @return [Array<String>]
      #
      def ip_search
        res = client.query_by_ip(query)
        return [] if res.nil?

        records = res["passive_dns"] || []
        records.filter_map do |record|
          record_type = record["record_type"]
          hostname = record["hostname"]

          hostname if record_type == "A"
        end.uniq
      end
    end
  end
end
