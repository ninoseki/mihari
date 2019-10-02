# frozen_string_literal: true

require "censu"

module Mihari
  module Analyzers
    class Censys < Base
      attr_reader :title
      attr_reader :description
      attr_reader :query
      attr_reader :tags

      def initialize(query, title: nil, description: nil, tags: [])
        super()

        @query = query
        @title = title || "Censys lookup"
        @description = description || "query = #{query}"
        @tags = tags
      end

      def artifacts
        ipv4s = []
        res = api.ipv4.search(query: query)
        res.each_page do |page|
          page.each { |result| ipv4s << result.ip }
        end

        ipv4s
      end

      private

      def config_keys
        %w(CENSYS_ID CENSYS_SECRET)
      end

      def api
        raise ArgumentError, configuration_status unless configured?

        @api ||= ::Censys::API.new
      end
    end
  end
end
