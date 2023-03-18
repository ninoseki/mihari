# frozen_string_literal: true

module Mihari
  module Analyzers
    class SecurityTrails < Base
      include Mixins::Refang

      param :query

      # @return [String, nil]
      attr_reader :type

      # @return [String, nil]
      attr_reader :api_key

      # @return [String]
      attr_reader :query

      def initialize(*args, **kwargs)
        super

        @query = refang(query)
        @type = TypeChecker.type(query)

        @api_key = kwargs[:api_key] || Mihari.config.securitytrails_api_key
      end

      def artifacts
        case type
        when "domain"
          domain_search
        when "ip"
          ip_search
        when "mail"
          mail_search
        else
          raise InvalidInputError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?
        end
      end

      private

      def configuration_keys
        %w[securitytrails_api_key]
      end

      def client
        @client ||= Clients::SecurityTrails.new(api_key: api_key)
      end

      #
      # Check whether a type is valid or not
      #
      # @return [Boolean]
      #
      def valid_type?
        %w[ip domain mail].include? type
      end

      #
      # Domain search
      #
      # @return [Array<String>]
      #
      def domain_search
        records = client.get_all_dns_history(query, type: "a")
        records.map do |record|
          (record["values"] || []).map { |value| value["ip"] }
        end.flatten.compact.uniq
      end

      #
      # IP search
      #
      # @return [Array<Mihari::Artifact>]
      #
      def ip_search
        records = client.search_by_ip(query)
        records.filter_map do |record|
          data = record["hostname"]
          Artifact.new(data: data, source: source, metadata: record)
        end
      end

      #
      # Mail search
      #
      # @return [Array<String>]
      #
      def mail_search
        records = client.search_by_mail(query)
        records.filter_map do |record|
          data = record["hostname"]
          Artifact.new(data: data, source: source, metadata: record)
        end
      end
    end
  end
end
