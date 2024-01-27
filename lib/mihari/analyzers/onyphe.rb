# frozen_string_literal: true

require "normalize_country"

module Mihari
  module Analyzers
    #
    # Onyphe analyzer
    #
    class Onyphe < Base
      # @return [String, nil]
      attr_reader :api_key

      #
      # @param [String] query
      # @param [Hash, nil] options
      # @param [String, nil] api_key
      #
      def initialize(query, options: nil, api_key: nil)
        super(query, options:)

        @api_key = api_key || Mihari.config.onyphe_api_key
      end

      def artifacts
        client.datascan_with_pagination(
          query,
          pagination_limit:
        ).map(&:artifacts).flatten
      end

      private

      def client
        Clients::Onyphe.new(
          api_key:,
          pagination_interval:,
          timeout:
        )
      end
    end
  end
end
