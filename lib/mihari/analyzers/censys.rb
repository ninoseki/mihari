# frozen_string_literal: true

require "censu"

module Mihari
  module Analyzers
    class Censys < Base
      attr_reader :title
      attr_reader :description
      attr_reader :query
      attr_reader :tags

      CENSYS_ID_KEY = "CENSYS_ID"
      CENSYS_SECRET_KEY = "CENSYS_SECRET"

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

      # @return [true, false]
      def valid?
        censys_id? && censys_secret?
      end

      private

      # @return [true, false]
      def censys_id?
        ENV.key? CENSYS_ID_KEY
      end

      # @return [true, false]
      def censys_secret?
        ENV.key? CENSYS_SECRET_KEY
      end

      def api
        raise ArgumentError, "#{CENSYS_ID_KEY} and #{CENSYS_SECRET_KEY} are required" unless valid?

        @api ||= ::Censys::API.new
      end
    end
  end
end
