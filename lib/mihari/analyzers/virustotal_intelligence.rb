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
        search_with_cursor.map(&:to_artifacts).flatten
      end

      private

      def configuration_keys
        %w[virustotal_api_key]
      end

      #
      # VT API
      #
      # @return [::VirusTotal::API]
      #
      def client
        @client = Clients::VirusTotal.new(api_key: api_key)
      end

      #
      # Search with cursor
      #
      # @return [Array<Structs::VirusTotalIntelligence::Response>]
      #
      def search_with_cursor
        cursor = nil
        responses = []

        pagination_limit.times do
          response = Structs::VirusTotalIntelligence::Response.from_dynamic!(client.intel_search(query,
            cursor: cursor))
          responses << response
          break if response.meta.cursor.nil?

          cursor = response.meta.cursor
          # sleep #{interval} seconds to avoid the rate limitation (if it is set)
          sleep_interval
        end

        responses
      end
    end
  end
end
