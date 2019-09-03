# frozen_string_literal: true

require "crtsh"

module Mihari
  module Analyzers
    class Crtsh < Base
      attr_reader :api
      attr_reader :title
      attr_reader :description
      attr_reader :query
      attr_reader :tags

      def initialize(query, title: nil, description: nil, tags: [])
        super()

        @api = ::Crtsh::API.new
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

      def search
        api.search(query)
      rescue ::Crtsh::Error => _e
        []
      end
    end
  end
end
