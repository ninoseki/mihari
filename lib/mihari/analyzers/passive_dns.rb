# frozen_string_literal: true

require "parallel"

module Mihari
  module Analyzers
    class PassiveDNS < Base
      param :query
      option :title, default: proc { "PassiveDNS cross search" }
      option :description, default: proc { "query = #{query}" }
      option :tags, default: proc { [] }

      attr_reader :type

      ANALYZERS = [
        Mihari::Analyzers::CIRCL,
        Mihari::Analyzers::OTX,
        Mihari::Analyzers::PassiveTotal,
        Mihari::Analyzers::Pulsedive,
        Mihari::Analyzers::SecurityTrails,
        Mihari::Analyzers::VirusTotal
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
        %w[ip domain].include? type
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
      rescue Faraday::Error, ::PassiveCIRCL::Error, ::PassiveTotal::Error, ::Pulsedive::ResponseError, ::SecurityTrails::Error, ::VirusTotal::Error => _e
        nil
      end
    end
  end
end
