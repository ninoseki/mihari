# frozen_string_literal: true

require "shodan"

module Mihari
  module Analyzers
    class Shodan < Base
      attr_reader :title
      attr_reader :description
      attr_reader :query
      attr_reader :tags

      def initialize(query, title: nil, description: nil, tags: [])
        super()

        @query = query
        @title = title || "Shodan lookup"
        @description = description || "query = #{query}"
        @tags = tags
      end

      def artifacts
        results = search
        return [] unless results || results.empty?

        results.map do |result|
          matches = result.dig("matches") || []
          matches.map do |match|
            match.dig "ip_str"
          end.compact
        end.flatten.compact.uniq
      end

      private

      PAGE_SIZE = 100

      def config_keys
        %w(shodan_api_key)
      end

      def api
        @api ||= ::Shodan::API.new(key: Mihari.config.shodan_api_key)
      end

      def search_with_page(query, page: 1)
        api.host.search(query, page: page)
      rescue ::Shodan::Error => e
        raise RetryableError, e if e.message.include?("request timed out")

        raise e
      end

      def search
        responses = []
        (1..Float::INFINITY).each do |page|
          res = search_with_page(query, page: page)
          break unless res

          responses << res
          break if res.dig("total").to_i <= page * PAGE_SIZE
        end
        responses
      end
    end
  end
end
