# frozen_string_literal: true

module Mihari
  module Analyzers
    #
    # ZoomEye analyzer
    #
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
        super(query, options:)

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
          raise ValueError, "#{type} type is not supported." unless valid_type?
        end
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
        Clients::ZoomEye.new(
          api_key:,
          pagination_interval:,
          timeout:
        )
      end

      #
      # Convert responses into an array of String
      #
      # @param [Hash] res
      #
      # @return [Array<Mihari::Models::Artifact>]
      #
      def convert(res)
        matches = res["matches"] || []
        matches.map do |match|
          data = match["ip"]

          if data.is_a?(Array)
            data.map { |d| Models::Artifact.new(data: d, metadata: match) }
          else
            Models::Artifact.new(data:, metadata: match)
          end
        end.flatten
      end
    end
  end
end
