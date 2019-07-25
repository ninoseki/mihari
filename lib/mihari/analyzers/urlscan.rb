# frozen_string_literal: true

require "urlscan"

module Mihari
  module Analyzers
    class Urlscan < Base
      attr_reader :api
      attr_reader :title
      attr_reader :description
      attr_reader :query
      attr_reader :tags

      def initialize(query, tags: [])
        super()

        @api = ::UrlScan::API.new
        @query = query
        @title = "urlscan lookup"
        @description = "query = #{query}"
        @tags = tags
      end

      def artifacts
        result = search
        return [] unless result

        results = result.dig("results") || []
        results.map do |match|
          match.dig "task", "url"
        end.compact
      end

      private

      def search
        api.search(query)
      rescue ::UrlScan::ResponseError => _e
        nil
      end
    end
  end
end
