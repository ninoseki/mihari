# frozen_string_literal: true

require "passivetotal"

module Mihari
  module Analyzers
    class PassiveTotal < Base
      include Mixins::Refang

      param :query

      # @return [String, nil]
      attr_reader :type

      # @return [String, nil]
      attr_reader :username

      # @return [String, nil]
      attr_reader :api_key

      def initialize(*args, **kwargs)
        super(*args, **kwargs)

        @query = refang(query)
        @type = TypeChecker.type(query)

        @username = kwargs[:username] || Mihari.config.passivetotal_username
        @api_key = kwargs[:api_key] || Mihari.config.passivetotal_api_key
      end

      def artifacts
        search || []
      end

      def configured?
        configuration_keys.all? { |key| Mihari.config.send(key) } || (username? && api_key?)
      end

      private

      def configuration_keys
        %w[passivetotal_username passivetotal_api_key]
      end

      def client
        @client ||= Clients::PassiveTotal.new(username: username, api_key: api_key)
      end

      #
      # Check whether a type is valid or not
      #
      # @return [Boolean]
      #
      def valid_type?
        %w[ip domain mail hash].include? type
      end

      #
      # Passive DNS/SSL, reverse whois search
      #
      # @return [Array<String>]
      #
      def search
        case type
        when "domain", "ip"
          passive_dns_search
        when "mail"
          reverse_whois_search
        when "hash"
          ssl_search
        else
          raise InvalidInputError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?
        end
      end

      #
      # Passive DNS search
      #
      # @return [Array<String>]
      #
      def passive_dns_search
        res = client.passive_dns_search(query)
        res["results"] || []
      end

      #
      # Reverse whois search
      #
      # @return [Array<Mihari::Artifact>]
      #
      def reverse_whois_search
        res = client.reverse_whois_search(query: query, field: "email")
        results = res["results"] || []
        results.map do |result|
          data = result["domain"]
          Artifact.new(data: data, source: source, metadata: result)
        end.flatten
      end

      #
      # Passive SSL search
      #
      # @return [Array<Mihari::Artifact>]
      #
      def ssl_search
        res = client.ssl_search(query)
        results = res["results"] || []
        results.map do |result|
          data = result["ipAddresses"]
          data.map { |d| Artifact.new(data: d, source: source, metadata: result) }
        end.flatten
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
