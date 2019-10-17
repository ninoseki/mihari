# frozen_string_literal: true

require "zoomeye"

module Mihari
  module Analyzers
    class ZoomEye < Base
      attr_reader :title
      attr_reader :description
      attr_reader :query
      attr_reader :tags
      attr_reader :type

      def initialize(query, title: nil, description: nil, tags: [], type: "host")
        super()

        @query = query
        @title = title || "ZoomEye lookup"
        @description = description || "query = #{query}"
        @tags = tags
        @type = type
      end

      def artifacts
        case type
        when "host"
          host_lookup
        when "web"
          web_lookup
        else
          raise TypeError, "#{type} type is not supported." unless valid_type?
        end
      end

      private

      def valid_type?
        %w(host web).include? type
      end

      def config_keys
        %w(ZOOMEYE_USERNAME ZOOMEYE_PASSWORD)
      end

      def api
        @api ||= ::ZoomEye::API.new
      end

      def convert_responses(responses)
        responses.map do |res|
          matches = res.dig("matches") || []
          matches.map do |match|
            match.dig "ip"
          end
        end.flatten.compact.uniq
      end

      def _host_lookup(query, page: 1)
        api.host.search(query, page: page)
      rescue ::ZoomEye::Error => _e
        nil
      end

      def host_lookup
        responses = []

        res = _host_lookup(query)
        total = res.dig("total").to_f
        max = (total / 10.0).ceil
        responses << res

        (2..max).each do |page|
          responses << _host_lookup(query, page: page)
        end
        convert_responses responses.compact
      end

      def _web_lookup(query, page: 1)
        api.web.search(query, page: page)
      rescue ::ZoomEye::Error => _e
        nil
      end

      def web_lookup
        responses = []

        res = _web_lookup(query)
        total = res.dig("total").to_f
        max = (total / 10.0).ceil
        responses << res

        (2..max).each do |page|
          responses << _web_lookup(query, page: page)
        end
        convert_responses responses.compact
      end
    end
  end
end
