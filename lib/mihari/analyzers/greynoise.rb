# frozen_string_literal: true

module Mihari
  module Analyzers
    class GreyNoise < Base
      param :query

      # @return [String, nil]
      attr_reader :api_key

      # @return [String]
      attr_reader :query

      def initialize(*args, **kwargs)
        super(*args, **kwargs)

        @api_key = kwargs[:api_key] || Mihari.config.greynoise_api_key
      end

      def artifacts
        res = search
        res.to_artifacts
      end

      private

      PAGE_SIZE = 10_000

      def configuration_keys
        %w[greynoise_api_key]
      end

      def client
        @client ||= Clients::GreyNoise.new(api_key: api_key)
      end

      #
      # Search
      #
      # @return [Hash]
      #
      def search
        client.gnql_search(query, size: PAGE_SIZE)
      end
    end
  end
end
