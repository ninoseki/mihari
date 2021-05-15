# frozen_string_literal: true

require "parallel"

module Mihari
  module Analyzers
    class FreeText < Base
      param :query
      option :title, default: proc { "Free text cross search" }
      option :description, default: proc { "query = #{query}" }
      option :tags, default: proc { [] }

      ANALYZERS = [
        Mihari::Analyzers::BinaryEdge,
        Mihari::Analyzers::Censys
      ].freeze

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
