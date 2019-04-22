# frozen_string_literal: true

require "censu"

module Mihari
  module Analyzers
    class Censys < Base
      attr_reader :api
      attr_reader :title
      attr_reader :description
      attr_reader :query

      def initialize(query)
        super()

        raise ArgumentError, "CENSYS_ID and CENSYS_SECRET are required" unless valid?

        @api = ::Censys::API.new
        @query = query
        @title = "Censys lookup"
        @description = "Query: #{query}"
      end

      def artifacts
        ipv4s = []
        res = api.ipv4.search(query: query)
        res.each_page do |page|
          page.each { |result| ipv4s << result.ip }
        end

        ipv4s
      end

      # @return [true, false]
      def censys_id?
        ENV.key? "CENSYS_ID"
      end

      # @return [true, false]
      def censys_secret?
        ENV.key? "CENSYS_SECRET"
      end

      # @return [true, false]
      def valid?
        censys_id? && censys_secret?
      end
    end
  end
end
