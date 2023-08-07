# frozen_string_literal: true

module Mihari
  module Analyzers
    class ZoomEye < Base
      # @return [String, nil]
      attr_reader :api_key

      # @return [String]
      attr_reader :type

      #
      # @param [String] query
      # @param [Hash, nil] options
      # @param [String, nil] api_key
      # @param [String] type
      #
      def initialize(query, options: nil, api_key: nil, type: "host")
        super(query, options: options)

        @type = type
        @api_key = api_key || Mihari.config.zoomeye_api_key
      end

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

      def client
        @client ||= Clients::ZoomEye.new(api_key: api_key)
      end

      #
      # Convert responses into an array of String
      #
      # @param [Array<Hash>] responses
      #
      # @return [Array<Mihari::Artifact>]
      #
      def convert_responses(responses)
        responses.map do |res|
          matches = res["matches"] || []
          matches.map do |match|
            data = match["ip"]

            if data.is_a?(Array)
              data.map { |d| Artifact.new(data: d, source: source, metadata: match) }
            else
              Artifact.new(data: data, source: source, metadata: match)
            end
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
        client.host_search(query, page: page)
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
          sleep_interval
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
        client.web_search(query, page: page)
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
          sleep_interval
        end
        convert_responses responses.compact
      end
    end
  end
end
