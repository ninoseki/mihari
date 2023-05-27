# frozen_string_literal: true

module Mihari
  module Analyzers
    class VirusTotalIntelligence < Base
      param :query

      option :interval, default: proc { 0 }

      # @return [String, nil]
      attr_reader :api_key

      # @return [String]
      attr_reader :query

      # @return [Integer]
      attr_reader :interval

      def initialize(*args, **kwargs)
        super

        @query = query

        @api_key = kwargs[:api_key] || Mihari.config.virustotal_api_key
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

        loop do
          response = Structs::VirusTotalIntelligence::Response.from_dynamic!(client.intel_search(query, cursor: cursor))
          responses << response
          break if response.meta.cursor.nil?

          cursor = response.meta.cursor
          # sleep #{interval} seconds to avoid the rate limitation (if it is set)
          sleep interval
        end

        responses
      end
    end
  end
end
