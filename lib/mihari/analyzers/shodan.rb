# frozen_string_literal: true

module Mihari
  module Analyzers
    class Shodan < Base
      param :query

      option :interval, default: proc { 0 }

      # @return [String, nil]
      attr_reader :api_key

      # @return [Integer]
      attr_reader :interval

      # @return [String]
      attr_reader :query

      def initialize(*args, **kwargs)
        super(*args, **kwargs)

        @api_key = kwargs[:api_key] || Mihari.config.shodan_api_key
      end

      def artifacts
        results = search
        return [] if results.empty?

        results.map(&:to_artifacts).flatten.uniq(&:data)
      end

      private

      PAGE_SIZE = 100

      def configuration_keys
        %w[shodan_api_key]
      end

      def client
        @client ||= Clients::Shodan.new(api_key: api_key)
      end

      #
      # Search with pagination
      #
      # @param [Integer] page
      #
      # @return [Structs::Shodan::Result]
      #
      def search_with_page(page: 1)
        client.search(query, page: page)
      end

      #
      # Search
      #
      # @return [Array<Structs::Shodan::Result>]
      #
      def search
        responses = []
        (1..Float::INFINITY).each do |page|
          res = search_with_page(page: page)
          responses << res
          break if res.total <= page * PAGE_SIZE

          # sleep #{interval} seconds to avoid the rate limitation (if it is set)
          sleep interval
        rescue JSON::ParserError
          # ignore JSON::ParserError
          # ref. https://github.com/ninoseki/mihari/issues/197
          next
        end
        responses
      end
    end
  end
end
