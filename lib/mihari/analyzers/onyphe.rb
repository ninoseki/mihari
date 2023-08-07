# frozen_string_literal: true

require "normalize_country"

module Mihari
  module Analyzers
    class Onyphe < Base
      # @return [String, nil]
      attr_reader :api_key

      #
      # @param [String] query
      # @param [Hash, nil] options
      # @param [String, nil] api_key
      #
      def initialize(query, options: nil, api_key: nil)
        super(query, options: options)

        @api_key = api_key || Mihari.config.onyphe_api_key
      end

      def artifacts
        responses = search
        return [] unless responses

        responses.map(&:to_artifacts).flatten
      end

      private

      PAGE_SIZE = 10

      def configuration_keys
        %w[onyphe_api_key]
      end

      def client
        @client ||= Clients::Onyphe.new(api_key: api_key)
      end

      #
      # Search with pagination
      #
      # @param [String] query
      # @param [Integer] page
      #
      # @return [Structs::Onyphe::Response]
      #
      def search_with_page(query, page: 1)
        client.datascan(query, page: page)
      end

      #
      # Search
      #
      # @return [Array<Structs::Onyphe::Response>]
      #
      def search
        responses = []
        (1..Float::INFINITY).each do |page|
          res = search_with_page(query, page: page)
          responses << res

          total = res.total
          break if total <= page * PAGE_SIZE

          # sleep #{interval} seconds to avoid the rate limitation (if it is set)
          sleep_interval
        end
        responses
      end
    end
  end
end
