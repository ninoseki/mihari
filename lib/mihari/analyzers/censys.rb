# frozen_string_literal: true

require "censu"

module Mihari
  module Analyzers
    class Censys < Base
      attr_reader :api
      attr_reader :title
      attr_reader :description
      attr_reader :query
      attr_reader :tags

      CENSYS_ID_KEY = "CENSYS_ID"
      CENSYS_SECRET_KEY = "CENSYS_SECRET"

      def initialize(query, tags: [])
        super()

        raise ArgumentError, "#{CENSYS_ID_KEY} and #{CENSYS_SECRET_KEY} are required" unless valid?

        @api = ::Censys::API.new
        @query = query
        @title = "Censys lookup"
        @description = "Query: #{query}"
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

      # @return [true, false]
      def censys_id?
        ENV.key? CENSYS_ID_KEY
      end

      # @return [true, false]
      def censys_secret?
        ENV.key? CENSYS_SECRET_KEY
      end

      # @return [true, false]
      def valid?
        censys_id? && censys_secret?
      end
    end
  end
end
