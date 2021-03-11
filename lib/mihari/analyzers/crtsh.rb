# frozen_string_literal: true

require "crtsh"

module Mihari
  module Analyzers
    class Crtsh < Base
      attr_reader :title, :description, :query, :tags, :exclude_expired

      def initialize(query, title: nil, description: nil, tags: [], exclude_expired: nil)
        super()

        @query = query
        @title = title || "crt.sh lookup"
        @description = description || "query = #{query}"
        @tags = tags

        @exclude_expired = exclude_expired.nil? ? true : exclude_expired
      end

      def artifacts
        results = search
        name_values = results.map { |result| result.dig("name_value") }.compact
        name_values.map(&:lines).flatten.uniq.map(&:chomp)
      end

      private

      def api
        @api ||= ::Crtsh::API.new
      end

      def search
        exclude = exclude_expired ? "expired" : nil
        api.search(query, exclude: exclude)
      rescue ::Crtsh::Error => _e
        []
      end
    end
  end
end
