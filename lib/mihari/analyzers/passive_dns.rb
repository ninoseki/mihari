# frozen_string_literal: true

require "parallel"

module Mihari
  module Analyzers
    class PassiveDNS < Base
      attr_reader :query
      attr_reader :type

      attr_reader :title
      attr_reader :description
      attr_reader :tags

      ANALYZERS = [
        Mihari::Analyzers::CIRCL,
        Mihari::Analyzers::PassiveTotal,
        Mihari::Analyzers::Pulsedive,
        Mihari::Analyzers::SecurityTrails,
        Mihari::Analyzers::VirusTotal,
      ].freeze

      def initialize(query, title: nil, description: nil, tags: [])
        super()

        @query = query
        @type = TypeChecker.type(query)

        @title = title || "PassiveDNS cross search"
        @description = description || "query = #{query}"
        @tags = tags
      end

      def artifacts
        Parallel.map(analyzers) do |analyzer|
          run_analyzer analyzer
        end.flatten
      end

      private

      def valid_type?
        %w(ip domain).include? type
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
      rescue ::PassiveCIRCL::Error, ::PassiveTotal::Error, ::Pulsedive::ResponseError, ::SecurityTrails::Error, ::VirusTotal::Error => _e
        nil
      end
    end
  end
end
