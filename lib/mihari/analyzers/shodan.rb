# frozen_string_literal: true

require "shodan"

module Mihari
  module Analyzers
    class Shodan < Base
      param :query
      option :title, default: proc { "Shodan lookup" }
      option :description, default: proc { "query = #{query}" }
      option :tags, default: proc { [] }

      def artifacts
        results = search
        return [] unless results || results.empty?

        results.map do |result|
          matches = result["matches"] || []
          matches.filter_map do |match|
            match["ip_str"]
          end
        end.flatten.compact.uniq
      end

      private

      PAGE_SIZE = 100

      def config_keys
        %w[shodan_api_key]
      end

      def api
        @api ||= ::Shodan::API.new(key: Mihari.config.shodan_api_key)
      end

      def search_with_page(query, page: 1)
        api.host.search(query, page: page)
      rescue ::Shodan::Error => e
        raise RetryableError, e if e.message.include?("request timed out")

        raise e
      end

      def search
        responses = []
        (1..Float::INFINITY).each do |page|
          res = search_with_page(query, page: page)
          break unless res

          responses << res
          break if res["total"].to_i <= page * PAGE_SIZE
        rescue JSON::ParserError
          # ignore JSON::ParserError
          # ref. https://github.com/ninoseki/mihari/issues/197
          next
        end
        responses
      end
    end
  end
end
