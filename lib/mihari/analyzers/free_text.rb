# frozen_string_literal: true

require "parallel"

module Mihari
  module Analyzers
    class FreeText < Base
      attr_reader :query

      attr_reader :title
      attr_reader :description
      attr_reader :tags

      ANALYZERS = [
        Mihari::Analyzers::BinaryEdge,
        Mihari::Analyzers::Censys,
      ].freeze

      def initialize(query, title: nil, description: nil, tags: [])
        super()

        @query = query

        @title = title || "Free text cross search"
        @description = description || "query = #{query}"
        @tags = tags
      end

      def artifacts
        Parallel.map(analyzers) do |analyzer|
          run_analyzer analyzer
        end.flatten
      end

      private

      def analyzers
        ANALYZERS.map do |klass|
          klass.new(query)
        end
      end

      def run_analyzer(analyzer)
        analyzer.artifacts
      rescue ArgumentError, InvalidInputError => _e
        nil
      rescue ::BinaryEdge::Error, ::Censys::Error => _e
        nil
      end
    end
  end
end
