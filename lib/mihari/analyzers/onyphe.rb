# frozen_string_literal: true

require "onyphe"

module Mihari
  module Analyzers
    class Onyphe < Base
      attr_reader :api
      attr_reader :title
      attr_reader :description
      attr_reader :query
      attr_reader :tags

      def initialize(query, tags: [])
        super()

        @api = ::Onyphe::API.new
        @query = query
        @title = "Onyphe lookup"
        @description = "Query: #{query}"
        @tags = tags
      end

      def artifacts
        result = search
        return [] unless result

        results = result.dig("results") || []
        results.map { |e| e.dig("ip") }.compact
      end

      private

      def search
        api.datascan(query)
      rescue ::Onyphe::Error => _e
        nil
      end
    end
  end
end
