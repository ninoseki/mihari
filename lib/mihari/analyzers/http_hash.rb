# frozen_string_literal: true

require "parallel"

module Mihari
  module Analyzers
    class HTTPHash < Base
      attr_reader :md5
      attr_reader :sha256
      attr_reader :mmh3

      attr_reader :title
      attr_reader :description
      attr_reader :tags

      def initialize(_query, md5: nil, sha256: nil, mmh3: nil, title: nil, description: nil, tags: [])
        super()

        @md5 = md5
        @sha256 = sha256
        @mmh3 = mmh3

        @title = title || "HTTP hash cross search"
        @description = description || "query = #{query}"
        @tags = tags
      end

      def artifacts
        Parallel.map(analyzers) do |analyzer|
          run_analyzer analyzer
        end.flatten
      end

      private

      def valid_query?
        [md5, sha256, mmh3].compact.any?
      end

      def query
        [
          md5 ? "md5:#{md5}" : nil,
          sha256 ? "sha256:#{sha256}" : nil,
          mmh3 ? "mmh3:#{mmh3}" : nil,
        ].compact.join(",")
      end

      def binary_edge
        return nil unless sha256

        BinaryEdge.new sha256
      end

      def censys
        return nil unless sha256

        Censys.new sha256
      end

      def onyphe
        return nil unless md5

        Onyphe.new "app.http.bodymd5:#{md5}"
      end

      def shodan
        return nil unless mmh3

        Shodan.new "http.html_hash:#{mmh3}"
      end

      def analyzers
        raise InvalidInputError, "No hashes are given." unless valid_query?

        [
          binary_edge,
          censys,
          onyphe,
          shodan,
        ].compact
      end

      def run_analyzer(analyzer)
        analyzer.artifacts
      rescue ArgumentError, InvalidInputError => _e
        nil
      rescue ::BinaryEdge::Error, ::Censys::ResponseError, ::Onyphe::Error, ::Shodan::Error => _e
        nil
      end
    end
  end
end
