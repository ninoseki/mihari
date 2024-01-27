# frozen_string_literal: true

module Mihari
  module Analyzers
    #
    # PassiveTotal analyzer
    #
    class PassiveTotal < Base
      include Concerns::Refangable

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
        super(refang(query), options:)

        @type = DataType.type(query)

        @username = username || Mihari.config.passivetotal_username
        @api_key = api_key || Mihari.config.passivetotal_api_key
      end

      def artifacts
        case type
        when "domain", "ip"
          passive_dns_search
        when "mail"
          reverse_whois_search
        when "hash"
          ssl_search
        else
          raise ValueError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?
        end
      end

      def configured?
        configuration_keys? || (username? && api_key?)
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

      def passive_dns_search
        res = client.passive_dns_search(query)
        res["results"] || []
      end

      def reverse_whois_search
        res = client.reverse_whois_search(query)
        (res["results"] || []).map do |result|
          data = result["domain"]
          Models::Artifact.new(data:, metadata: result)
        end
      end

      def ssl_search
        res = client.ssl_search(query)
        (res["results"] || []).map do |result|
          data = result["ipAddresses"]
          data.map { |d| Models::Artifact.new(data: d, metadata: result) }
        end.flatten
      end

      def client
        Clients::PassiveTotal.new(username:, api_key:, timeout:)
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
    end
  end
end
