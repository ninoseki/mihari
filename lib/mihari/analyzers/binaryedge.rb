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
        results = search
        return [] unless results || results.empty?

        results.map do |result|
          events = result["events"] || []
          events.filter_map do |event|
            data = event.dig("target", "ip")
            data.nil? ? nil : Artifact.new(data: data, source: source, metadata: event)
          end
        end.flatten
      end

      private

      PAGE_SIZE = 20

      #
      # Search with pagination
      #
      # @param [Integer] page
      #
      # @return [Hash]
      #
      def search_with_page(page: 1)
        client.search(query, page: page)
      rescue StatusCodeError => e
        raise RetryableError, e if e.message.include?("Request time limit exceeded")

        raise e
      end

      #
      # Search
      #
      # @return [Array<Hash>]
      #
      def search
        responses = []
        (1..pagination_limit).each do |page|
          res = search_with_page(page: page)
          total = res["total"].to_i

          responses << res
          break if total <= page * PAGE_SIZE

          # sleep #{interval} seconds to avoid the rate limitation (if it is set)
          sleep_interval
        end
        responses
      end

      def configuration_keys
        %w[binaryedge_api_key]
      end

      #
      #
      # @return [Mihari::Clients::BinaryEdge]
      #
      def client
        @client ||= Clients::BinaryEdge.new(api_key: api_key)
      end
    end
  end
end
