# frozen_string_literal: true

require "parallel"

module Mihari
  module Analyzers
    class HTTPHash < Base
      attr_reader :md5, :sha256, :mmh3, :html, :title, :description, :tags

      def initialize(_query, md5: nil, sha256: nil, mmh3: nil, html: nil, title: nil, description: nil, tags: [])
        super()

        @md5 = md5
        @sha256 = sha256
        @mmh3 = mmh3

        @html = html
        load_from_html

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

      def load_from_html
        return unless html

        html_file = HTML.new(html)
        return unless html_file.exists?

        @md5 = html_file.md5
        @sha256 = html_file.sha256
        @mmh3 = html_file.mmh3
      end

      def query
        [
          md5 ? "md5:#{md5}" : nil,
          sha256 ? "sha256:#{sha256}" : nil,
          mmh3 ? "mmh3:#{mmh3}" : nil
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
          shodan
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
