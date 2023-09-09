# frozen_string_literal: true

module Mihari
  module Analyzers
    class BinaryEdge < Base
      # @return [String, nil]
      attr_reader :api_key

      #
      # @param [String] query
      # @param [Hash, nil] options
      # @param [String, nil] api_key
      #
      def initialize(query, options: nil, api_key: nil)
        super(query, options: options)

        @api_key = api_key || Mihari.config.binaryedge_api_key
      end

      def artifacts
        client.search_with_pagination(query, pagination_limit: pagination_limit).map do |res|
          events = res["events"] || []
          events.filter_map do |event|
            data = event.dig("target", "ip")
            data.nil? ? nil : Artifact.new(data: data, source: source, metadata: event)
          end
        end
      end

      def configuration_keys
        %w[binaryedge_api_key]
      end

      private

      #
      #
      # @return [Mihari::Clients::BinaryEdge]
      #
      def client
        @client ||= Clients::BinaryEdge.new(api_key: api_key, interval: interval)
      end
    end
  end
end
