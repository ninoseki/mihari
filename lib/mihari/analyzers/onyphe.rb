# frozen_string_literal: true

require "onyphe"

module Mihari
  module Analyzers
    class Onyphe < Base
      param :query
      option :title, default: proc { "Onyphe lookup" }
      option :description, default: proc { "query = #{query}" }
      option :tags, default: proc { [] }

      def artifacts
        results = search
        return [] unless results

        flat_results = results.map do |result|
          result["results"]
        end.flatten.compact

        flat_results.filter_map { |result| result["ip"] }.uniq
      end

      private

      PAGE_SIZE = 10

      def config_keys
        %w[onyphe_api_key]
      end

      def api
        @api ||= ::Onyphe::API.new(Mihari.config.onyphe_api_key)
      end

      def search_with_page(query, page: 1)
        api.simple.datascan(query, page: page)
      end

      def search
        responses = []
        (1..Float::INFINITY).each do |page|
          res = search_with_page(query, page: page)
          responses << res
          total = res["total"].to_i
          break if total <= page * PAGE_SIZE
        end
        responses
      end
    end
  end
end
