# frozen_string_literal: true

module Mihari
  module Analyzers
    #
    # SecurityTrails
    #
    class SecurityTrails < Base
      include Concerns::Refangable

      # @return [String, nil]
      attr_reader :type

      # @return [String, nil]
      attr_reader :api_key

      # @return [String]
      attr_reader :query

      #
      # @param [String] query
      # @param [Hash, nil] options
      # @param [String, nil] api_key
      #
      def initialize(query, options: nil, api_key: nil)
        super(refang(query), options: options)

        @type = DataType.type(query)

        @api_key = api_key || Mihari.config.securitytrails_api_key
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
          raise ValueError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?
        end
      end

      class << self
        #
        # @return [Array<String>, nil]
        #
        def key_aliases
          ["st"]
        end
      end

      private

      def domain_search
        client.get_all_dns_history(query, type: "a").map do |res|
          (res["records"] || []).map do |record|
            (record["values"] || []).map { |value| value["ip"] }
          end.flatten.compact.uniq
        end.flatten
      end

      def ip_search
        res = client.ip_search(query)
        (res["records"] || []).filter_map do |record|
          data = record["hostname"]
          Models::Artifact.new(data: data, metadata: record)
        end
      end

      def mail_search
        res = client.mail_search(query)
        (res["records"] || []).filter_map do |record|
          data = record["hostname"]
          Models::Artifact.new(data: data, metadata: record)
        end
      end

      def client
        Clients::SecurityTrails.new(api_key: api_key, timeout: timeout)
      end

      #
      # Check whether a type is valid or not
      #
      # @return [Boolean]
      #
      def valid_type?
        %w[ip domain mail].include? type
      end
    end
  end
end
