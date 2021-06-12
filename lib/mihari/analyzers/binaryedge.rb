# frozen_string_literal: true

require "binaryedge"

module Mihari
  module Analyzers
    class BinaryEdge < Base
      param :query
      option :title, default: proc { "BinaryEdge lookup" }
      option :description, default: proc { "query = #{query}" }
      option :tags, default: proc { [] }

      def artifacts
        results = search
        return [] unless results || results.empty?

        results.map do |result|
          events = result["events"] || []
          events.filter_map do |event|
            event.dig "target", "ip"
          end
        end.flatten.compact.uniq
      end

      private

      PAGE_SIZE = 20

      def search_with_page(query, page: 1)
        api.host.search(query, page: page)
      rescue ::BinaryEdge::Error => e
        raise RetryableError, e if e.message.include?("Request time limit exceeded")

        raise e
      end

      def search
        responses = []
        (1..Float::INFINITY).each do |page|
          res = search_with_page(query, page: page)
          total = res["total"].to_i

          responses << res
          break if total <= page * PAGE_SIZE
        end
        responses
      end

      def configuration_keys
        %w[binaryedge_api_key]
      end

      def api
        @api ||= ::BinaryEdge::API.new(Mihari.config.binaryedge_api_key)
      end
    end
  end
end
