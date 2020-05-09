# frozen_string_literal: true

require "onyphe"

module Mihari
  module Analyzers
    class Onyphe < Base
      attr_reader :title
      attr_reader :description
      attr_reader :query
      attr_reader :tags

      def initialize(query, title: nil, description: nil, tags: [])
        super()

        @query = query
        @title = title || "Onyphe lookup"
        @description = description || "query = #{query}"
        @tags = tags
      end

      def artifacts
        results = search
        return [] unless results

        flat_results = results.map do |result|
          result.dig("results")
        end.flatten.compact

        flat_results.map { |result| result.dig("ip") }.compact.uniq
      end

      private

      PAGE_SIZE = 10

      def config_keys
        %w(onyphe_api_key)
      end

      def api
        @api ||= ::Onyphe::API.new(Mihari.config.onyphe_api_key)
      end

      def search_with_page(query, page: 1)
        api.simple.datascan(query, page: page)
      end

      def search
        responses = []
        (1..Float::INFINITY).each do |page|
          res = search_with_page(query, page: page)
          responses << res
          total = res.dig("total").to_i
          break if total <= page * PAGE_SIZE
        end
        responses
      end
    end
  end
end
