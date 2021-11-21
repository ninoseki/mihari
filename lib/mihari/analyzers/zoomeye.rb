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

      option :interval, default: proc { 0 }

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

      #
      # Check whether a type is valid or not
      #
      # @return [Boolean]
      #
      def valid_type?
        %w[host web].include? type
      end

      def configuration_keys
        %w[zoomeye_api_key]
      end

      def api
        @api ||= ::ZoomEye::API.new(api_key: Mihari.config.zoomeye_api_key)
      end

      #
      # Convert responses into an array of String
      #
      # @param [Array<Hash>] responses
      #
      # @return [Array<String>]
      #
      def convert_responses(responses)
        responses.map do |res|
          matches = res["matches"] || []
          matches.map do |match|
            match["ip"]
          end
        end.flatten.compact.uniq
      end

      #
      # Host search
      #
      # @param [String] query
      # @param [Integer] page
      #
      # @return [Hash, nil]
      #
      def _host_search(query, page: 1)
        api.host.search(query, page: page)
      rescue ::ZoomEye::Error => _e
        nil
      end

      #
      # Host search
      #
      # @return [Array<String>]
      #
      def host_search
        responses = []
        (1..Float::INFINITY).each do |page|
          res = _host_search(query, page: page)
          break unless res

          total = res["total"].to_i
          responses << res
          break if total <= page * PAGE_SIZE

          # sleep #{interval} seconds to avoid the rate limitation (if it is set)
          sleep interval
        end
        convert_responses responses.compact
      end

      #
      # Web search
      #
      # @param [String] query
      # @param [Integer] page
      #
      # @return [Hash, nil]
      #
      def _web_search(query, page: 1)
        api.web.search(query, page: page)
      rescue ::ZoomEye::Error => _e
        nil
      end

      #
      # Web search
      #
      # @return [Array<String>]
      #
      def web_search
        responses = []
        (1..Float::INFINITY).each do |page|
          res = _web_search(query, page: page)
          break unless res

          total = res["total"].to_i
          responses << res
          break if total <= page * PAGE_SIZE

          # sleep #{interval} seconds to avoid the rate limitation (if it is set)
          sleep interval
        end
        convert_responses responses.compact
      end
    end
  end
end
