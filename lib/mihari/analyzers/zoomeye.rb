# frozen_string_literal: true

require "zoomeye"

module Mihari
  module Analyzers
    class ZoomEye < Base
      param :query
      option :title, default: proc { "ZoomEye search" }
      option :description, default: proc { "query = #{query}" }
      option :tags, default: proc { [] }
      option :type, default: proc { "host" }

      def artifacts
        case type
        when "host"
          host_search
        when "web"
          web_search
        else
          raise InvalidInputError, "#{type} type is not supported." unless valid_type?
        end
      end

      private

      PAGE_SIZE = 10

      def valid_type?
        %w[host web].include? type
      end

      def configuration_keys
        %w[zoomeye_api_key]
      end

      def api
        @api ||= ::ZoomEye::API.new(api_key: Mihari.config.zoomeye_api_key)
      end

      def convert_responses(responses)
        responses.map do |res|
          matches = res["matches"] || []
          matches.map do |match|
            match["ip"]
          end
        end.flatten.compact.uniq
      end

      def _host_search(query, page: 1)
        api.host.search(query, page: page)
      rescue ::ZoomEye::Error => _e
        nil
      end

      def host_search
        responses = []
        (1..Float::INFINITY).each do |page|
          res = _host_search(query, page: page)
          break unless res

          total = res["total"].to_i
          responses << res
          break if total <= page * PAGE_SIZE
        end
        convert_responses responses.compact
      end

      def _web_search(query, page: 1)
        api.web.search(query, page: page)
      rescue ::ZoomEye::Error => _e
        nil
      end

      def web_search
        responses = []
        (1..Float::INFINITY).each do |page|
          res = _web_search(query, page: page)
          break unless res

          total = res["total"].to_i
          responses << res
          break if total <= page * PAGE_SIZE
        end
        convert_responses responses.compact
      end
    end
  end
end
