# frozen_string_literal: true

require "shodan"

module Mihari
  module Analyzers
    class Shodan < Base
      attr_reader :api
      attr_reader :title
      attr_reader :description
      attr_reader :query
      attr_reader :tags

      def initialize(query, tags: [])
        super()

        @api = ::Shodan::API.new
        @query = query
        @title = "Shodan lookup"
        @description = "Query: #{query}"
        @tags = tags
      end

      def artifacts
        result = search
        return [] unless result

        matches = result.dig("matches") || []
        matches.map do |match|
          match.dig "ip_str"
        end.compact
      end

      private

      def search
        api.host.search(query)
      rescue ::Shodan::Error => _e
        nil
      end
    end
  end
end
