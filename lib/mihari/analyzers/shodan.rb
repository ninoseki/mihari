# frozen_string_literal: true

require "open-uri"
require "json"

module Mihari
  module Analyzers
    class Shodan < Base
      attr_reader :api_key
      attr_reader :title
      attr_reader :description
      attr_reader :query

      def initialize(query)
        super()

        api_key = ENV.fetch("SHODAN_API_KEY", nil)
        raise ArgumentError, "SHODAN_API_KEY is required" unless api_key

        @api_key = api_key
        @query = query
        @title = "Shodan lookup"
        @description = "Query: #{query}"
      end

      def artifacts
        result = search
        return [] unless result

        matches = result.dig("matches") || []
        matches.map do |match|
          match.dig "ip_str"
        end.compact
      end

      private

      def search
        uri = URI("https://api.shodan.io/shodan/host/search?key=#{api_key}&query=#{query}")
        begin
          JSON.parse uri.read
        rescue OpenURI::HTTPError
          nil
        end
      end
    end
  end
end
