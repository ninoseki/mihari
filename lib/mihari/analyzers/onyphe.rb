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
        result = search
        return [] unless result

        results = result.dig("results") || []
        results.map { |e| e.dig("ip") }.compact.uniq
      end

      private

      def config_keys
        %w(ONYPHE_API_KEY)
      end

      def api
        @api ||= ::Onyphe::API.new
      end

      def search
        api.datascan(query)
      end
    end
  end
end
