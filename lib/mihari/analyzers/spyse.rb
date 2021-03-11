# frozen_string_literal: true

require "spyse"
require "json"

module Mihari
  module Analyzers
    class Spyse < Base
      attr_reader :query, :type, :title, :description, :tags

      def initialize(query, title: nil, description: nil, tags: [], type: "domain")
        super()

        @query = query

        @title = title || "Spyse lookup"
        @description = description || "query = #{query}"
        @tags = tags
        @type = type
      end

      def artifacts
        lookup || []
      end

      private

      def search_params
        @search_params ||= JSON.parse(query)
      end

      def config_keys
        %w[spyse_api_key]
      end

      def api
        @api ||= ::Spyse::API.new(Mihari.config.spyse_api_key)
      end

      def valid_type?
        %w[ip domain cert].include? type
      end

      def domain_lookup
        res = api.domain.search(search_params, limit: 100)
        items = res.dig("data", "items") || []
        items.map do |item|
          item.dig("name")
        end.uniq.compact
      end

      def ip_lookup
        res = api.ip.search(search_params, limit: 100)
        items = res.dig("data", "items") || []
        items.map do |item|
          item.dig("ip")
        end.uniq.compact
      end

      def lookup
        case type
        when "domain"
          domain_lookup
        when "ip"
          ip_lookup
        else
          raise InvalidInputError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?
        end
      end
    end
  end
end
