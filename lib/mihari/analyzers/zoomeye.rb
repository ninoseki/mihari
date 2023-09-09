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
          client.host_search_with_pagination(query).map do |res|
            convert(res)
          end.flatten
        when "web"
          client.web_search_with_pagination(query).map do |res|
            convert(res)
          end.flatten
        else
          raise InvalidInputError, "#{type} type is not supported." unless valid_type?
        end
      end

      def configuration_keys
        %w[zoomeye_api_key]
      end

      private

      #
      # Check whether a type is valid or not
      #
      # @return [Boolean]
      #
      def valid_type?
        %w[host web].include? type
      end

      def client
        @client ||= Clients::ZoomEye.new(api_key: api_key, interval: interval)
      end

      #
      # Convert responses into an array of String
      #
      # @param [Hash] response
      #
      # @return [Array<Mihari::Artifact>]
      #
      def convert(res)
        matches = res["matches"] || []
        matches.map do |match|
          data = match["ip"]

          if data.is_a?(Array)
            data.map { |d| Artifact.new(data: d, source: source, metadata: match) }
          else
            Artifact.new(data: data, source: source, metadata: match)
          end
        end.flatten
      end
    end
  end
end
