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
        super(query, options:)

        @api_key = api_key || Mihari.config.binaryedge_api_key
      end

      def artifacts
        client.search_with_pagination(query, pagination_limit:).map(&:artifacts).flatten
      end

      private

      #
      #
      # @return [Mihari::Clients::BinaryEdge]
      #
      def client
        Clients::BinaryEdge.new(
          api_key:,
          pagination_interval:,
          timeout:
        )
      end
    end
  end
end
