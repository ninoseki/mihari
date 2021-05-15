# frozen_string_literal: true

require "parallel"

module Mihari
  module Analyzers
    class ReveseWhois < Base
      param :query
      option :title, default: proc { "ReveseWhois cross search" }
      option :description, default: proc { "query = #{query}" }
      option :tags, default: proc { [] }

      attr_reader :type

      ANALYZERS = [
        Mihari::Analyzers::PassiveTotal,
        Mihari::Analyzers::SecurityTrails
      ].freeze

      def initialize(*args, **kwargs)
        super

        @type = TypeChecker.type(query)
      end

      def artifacts
        Parallel.map(analyzers) do |analyzer|
          run_analyzer analyzer
        end.flatten
      end

      private

      def valid_type?
        %w[mail].include? type
      end

      def analyzers
        raise InvalidInputError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?

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
