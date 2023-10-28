# frozen_string_literal: true

module Mihari
  module Analyzers
    class SecurityTrails < Base
      include Mixins::Refang

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

        @type = TypeChecker.type(query)

        @api_key = api_key || Mihari.config.securitytrails_api_key
      end

      def artifacts
        case type
        when "domain"
          client.domain_search query
        when "ip"
          client.ip_search query
        when "mail"
          client.mail_search query
        else
          raise ValueError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?
        end
      end

      def configuration_keys
        %w[securitytrails_api_key]
      end

      class << self
        #
        # @return [Array<String>, nil]
        #
        def class_key_aliases
          ["st"]
        end
      end

      private

      def client
        @client ||= Clients::SecurityTrails.new(api_key: api_key, timeout: timeout)
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
