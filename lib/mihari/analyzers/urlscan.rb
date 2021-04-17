# frozen_string_literal: true

require "urlscan"

module Mihari
  module Analyzers
    class Urlscan < Base
      attr_reader :title, :description, :query, :tags, :target_type, :use_similarity

      def initialize(
        query,
        description: nil,
        tags: [],
        target_type: "url",
        title: nil,
        use_similarity: false
      )
        super()

        @query = query
        @title = title || "urlscan lookup"
        @description = description || "query = #{query}"
        @tags = tags

        @target_type = target_type
        @use_similarity = use_similarity

        raise InvalidInputError, "type should be url, domain or ip." unless valid_target_type?
      end

      def artifacts
        result = search
        return [] unless result

        results = result["results"] || []
        results.map do |match|
          match.dig "page", target_type
        end.compact.uniq
      end

      private

      def config_keys
        %w[urlscan_api_key]
      end

      def api
        @api ||= ::UrlScan::API.new(Mihari.config.urlscan_api_key)
      end

      def search
        return api.pro.similar(query) if use_similarity

        api.search(query, size: 10_000)
      end

      def valid_target_type?
        %w[url domain ip].include? target_type
      end
    end
  end
end
