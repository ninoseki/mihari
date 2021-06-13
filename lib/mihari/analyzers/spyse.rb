# frozen_string_literal: true

require "spyse"
require "json"

module Mihari
  module Analyzers
    class Spyse < Base
      param :query
      option :title, default: proc { "Spyse search" }
      option :description, default: proc { "query = #{query}" }
      option :type, default: proc { "domain" }
      option :tags, default: proc { [] }

      def artifacts
        search || []
      end

      private

      def search_params
        @search_params ||= JSON.parse(query)
      end

      def configuration_keys
        %w[spyse_api_key]
      end

      def api
        @api ||= ::Spyse::API.new(Mihari.config.spyse_api_key)
      end

      def valid_type?
        %w[ip domain cert].include? type
      end

      def domain_search
        res = api.domain.search(search_params, limit: 100)
        items = res.dig("data", "items") || []
        items.map do |item|
          item["name"]
        end.uniq.compact
      end

      def ip_search
        res = api.ip.search(search_params, limit: 100)
        items = res.dig("data", "items") || []
        items.map do |item|
          item["ip"]
        end.uniq.compact
      end

      def search
        case type
        when "domain"
          domain_search
        when "ip"
          ip_search
        else
          raise InvalidInputError, "#{query}(type: #{type || "unknown"}) is not supported." unless valid_type?
        end
      end
    end
  end
end
