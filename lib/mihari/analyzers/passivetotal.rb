# frozen_string_literal: true

module Mihari
  module Analyzers
    class PassiveTotal < Base
      include Mixins::Refang

      # @return [String, nil]
      attr_reader :type

      # @return [String, nil]
      attr_reader :username

      # @return [String, nil]
      attr_reader :api_key

      #
      # @param [String] query
      # @param [Hash, nil] options
      # @param [String, nil] api_key
      # @param [String, nil] username
      #
      def initialize(query, options: nil, api_key: nil, username: nil)
        super(refang(query), options: options)

        @type = TypeChecker.type(query)

        @username = username || Mihari.config.passivetotal_username
        @api_key = api_key || Mihari.config.passivetotal_api_key
      end

      def artifacts
        case type
        when "domain", "ip"
          client.passive_dns_search query
        when "mail"
          client.reverse_whois_search query
        when "hash"
          client.ssl_search query
        else
          raise ValueError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?
        end
      end

      def configured?
        configuration_keys? || (username? && api_key?)
      end

      def configuration_keys
        %w[passivetotal_username passivetotal_api_key]
      end

      class << self
        #
        # @return [Array<String>, nil]
        #
        def key_aliases
          ["pt"]
        end
      end

      private

      def client
        @client ||= Clients::PassiveTotal.new(username: username, api_key: api_key, timeout: timeout)
      end

      #
      # Check whether a type is valid or not
      #
      # @return [Boolean]
      #
      def valid_type?
        %w[ip domain mail hash].include? type
      end

      def username?
        !username.nil?
      end

      def api_key?
        !api_key.nil?
      end
    end
  end
end
