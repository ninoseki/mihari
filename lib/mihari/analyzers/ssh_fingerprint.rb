# frozen_string_literal: true

require "parallel"

module Mihari
  module Analyzers
    class SSHFingerprint < Base
      attr_reader :fingerprint

      attr_reader :title
      attr_reader :description
      attr_reader :tags

      def initialize(fingerprint, title: nil, description: nil, tags: [])
        super()

        @fingerprint = fingerprint

        @title = title || "SSH fingerprint cross search"
        @description = description || "fingerprint = #{fingerprint}"
        @tags = tags
      end

      def artifacts
        Parallel.map(analyzers) do |analyzer|
          run_analyzer analyzer
        end.flatten
      end

      private

      def valid_fingerprint?
        /^([0-9a-f]{2}:){15}[0-9a-f]{2}$/.match? fingerprint
      end

      def binary_edge
        BinaryEdge.new "ssh.fingerprint:\"#{fingerprint}\""
      end

      def shodan
        Shodan.new fingerprint
      end

      def analyzers
        raise InvalidInputError, "Invalid fingerprint is given." unless valid_fingerprint?

        [
          binary_edge,
          shodan,
        ].compact
      end

      def run_analyzer(analyzer)
        analyzer.artifacts
      rescue ArgumentError, InvalidInputError => _e
        nil
      rescue ::BinaryEdge::Error, ::Shodan::Error => _e
        nil
      end
    end
  end
end
