# frozen_string_literal: true

require "virustotal"

module Mihari
  module Analyzers
    class VirusTotalIntelligence < Base
      param :query

      option :interval, default: proc { 0 }

      # @return [String, nil]
      attr_reader :api_key

      def initialize(*args, **kwargs)
        super

        @query = query

        @api_key = kwargs[:api_key] || Mihari.config.virustotal_api_key
      end

      def artifacts
        responses = search_witgh_cursor
        responses.map do |response|
          response.data.map do |datum|
            Artifact.new(data: datum.value, source: source, metadata: datum.metadata)
          end
        end.flatten
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
      def api
        @api = ::VirusTotal::API.new(key: api_key)
      end

      #
      # Search with cursor
      #
      # @return [Array<Structs::VirusTotalIntelligence::Response>]
      #
      def search_witgh_cursor
        cursor = nil
        responses = []

        loop do
          response = Structs::VirusTotalIntelligence::Response.from_dynamic!(api.intelligence.search(query, cursor: cursor))
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
