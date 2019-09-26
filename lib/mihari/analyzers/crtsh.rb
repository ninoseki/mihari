# frozen_string_literal: true

require "crtsh"

module Mihari
  module Analyzers
    class Crtsh < Base
      attr_reader :title
      attr_reader :description
      attr_reader :query
      attr_reader :tags

      def initialize(query, title: nil, description: nil, tags: [])
        super()

        @query = query
        @title = title || "crt.sh lookup"
        @description = description || "query = #{query}"
        @tags = tags
      end

      def artifacts
        results = search
        results.map { |result| result.dig("name_value") }.compact.uniq
      end

      private

      def api
        @api ||= ::Crtsh::API.new
      end

      def search
        api.search(query)
      rescue ::Crtsh::Error => _e
        []
      end
    end
  end
end
