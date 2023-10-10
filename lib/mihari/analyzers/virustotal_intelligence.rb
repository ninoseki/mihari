# frozen_string_literal: true

module Mihari
  module Analyzers
    class VirusTotalIntelligence < Base
      # @return [String, nil]
      attr_reader :api_key

      #
      # @param [String] query
      # @param [Hash, nll] options
      # @param [String, nil] api_key
      #
      def initialize(query, options: nil, api_key: nil)
        super(query, options: options)

        @api_key = api_key || Mihari.config.virustotal_api_key
      end

      def artifacts
        client.intel_search_with_pagination(query, pagination_limit: pagination_limit).map(&:artifacts).flatten
      end

      def configuration_keys
        %w[virustotal_api_key]
      end

      private

      #
      # VT API
      #
      # @return [::VirusTotal::API]
      #
      def client
        @client = Clients::VirusTotal.new(api_key: api_key, interval: interval, timeout: timeout)
      end
    end
  end
end
