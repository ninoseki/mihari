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

      def config_keys
        %w(SHODAN_API_KEY)
      end

      def api
        @api ||= ::Shodan::API.new
      end

      def search_with_page(query, page: 1)
        api.host.search(query, page: page)
      rescue ::Shodan::Error => _e
        nil
      end

      def search
        responses = []
        (1..Float::INFINITY).each do |page|
          res = search_with_page(query, page: page)
          break unless res

          responses << res
          break if res.dig("total").to_i <= page * 100
        end
        responses
      end
    end
  end
end
