# frozen_string_literal: true

module Mihari
  module Analyzers
    class GreyNoise < Base
      PAGE_SIZE = 10_000

      # @return [String, nil]
      attr_reader :api_key

      #
      # @param [String] query
      # @param [Hash, nil] options
      # @param [String, nil] api_key
      #
      def initialize(query, options: nil, api_key: nil)
        super(query, options: options)

        @api_key = api_key || Mihari.config.greynoise_api_key
      end

      def artifacts
        client.gnql_search(query, size: PAGE_SIZE).to_artifacts
      end

      def configuration_keys
        %w[greynoise_api_key]
      end

      private

      def client
        @client ||= Clients::GreyNoise.new(api_key: api_key)
      end
    end
  end
end
