# frozen_string_literal: true

require "mihari/clients/validin"

module Mihari
  module Analyzers
    #
    # Validin analyzer
    #
    class Validin < Base
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
      #
      def initialize(query, options: nil, api_key: nil)
        super(refang(query), options:)

        @type = DataType.type(query)

        @api_key = api_key || Mihari.config.validin_api_key
      end

      def artifacts
        case type
        when "domain"
          dns_history_search
        when "ip"
          reverse_ip_search
        else
          raise ValueError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?
        end
      end

      private

      def dns_history_search
        res = client.dns_history_search(query)
        (res.dig("records", "A") || []).filter_map do |r|
          r["value"]
        end
      end

      def reverse_ip_search
        res = client.dns_history_search(query)
        (res.dig("records", "A") || []).filter_map do |r|
          r["value"]
        end
      end

      def client
        Clients::Validin.new(api_key:, timeout:)
      end

      #
      # Check whether a type is valid or not
      #
      # @return [Boolean]
      #
      def valid_type?
        %w[ip domain].include? type
      end
    end
  end
end
