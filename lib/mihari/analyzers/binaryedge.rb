# frozen_string_literal: true

module Mihari
  module Analyzers
    #
    # BinaryEdge analyzer
    #
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
        client.search_with_pagination(query, pagination_limit: pagination_limit).map(&:artifacts).flatten
      end

      class << self
        def configuration_keys
          %w[binaryedge_api_key]
        end
      end

      private

      #
      #
      # @return [Mihari::Clients::BinaryEdge]
      #
      def client
        Clients::BinaryEdge.new(
          api_key: api_key,
          pagination_interval: pagination_interval,
          timeout: timeout
        )
      end
    end
  end
end
