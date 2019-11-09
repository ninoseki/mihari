# frozen_string_literal: true

module Mihari
  module Analyzers
    class ReveseWhois < Base
      attr_reader :query
      attr_reader :type

      attr_reader :title
      attr_reader :description
      attr_reader :tags

      ANALYZERS = [
        Mihari::Analyzers::PassiveTotal,
        Mihari::Analyzers::SecurityTrails,
      ].freeze

      def initialize(query, title: nil, description: nil, tags: [])
        super()

        @query = query
        @type = TypeChecker.type(query)

        @title = title || "ReveseWhois cross search"
        @description = description || "query = #{query}"
        @tags = tags
      end

      def artifacts
        analyzers.map do |analyzer|
          run_analyzer analyzer
        end.flatten
      end

      private

      def valid_type?
        %w(mail).include? type
      end

      def analyzers
        raise InvalidInputError, "#{query}(type: #{type || 'unknown'}) is not supported." unless valid_type?

        ANALYZERS.map do |klass|
          klass.new(query)
        end
      end

      def run_analyzer(analyzer)
        analyzer.artifacts
      rescue ArgumentError, InvalidInputError => _e
        nil
      rescue ::PassiveTotal::Error, ::SecurityTrails::Error => _e
        nil
      end
    end
  end
end
