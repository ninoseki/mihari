# frozen_string_literal: true

require "urlscan"

module Mihari
  module Analyzers
    class Urlscan < Base
      param :query
      option :title, default: proc { "urlscan lookup" }
      option :description, default: proc { "query = #{query}" }
      option :tags, default: proc { [] }
      option :target_type, default: proc { "url" }
      option :use_similarity, default: proc { false }

      def initialize(*args, **kwargs)
        super

        raise InvalidInputError, "type should be url, domain or ip." unless valid_target_type?
      end

      def artifacts
        result = search
        return [] unless result

        results = result["results"] || []
        results.filter_map do |match|
          match.dig "page", target_type
        end.uniq
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
