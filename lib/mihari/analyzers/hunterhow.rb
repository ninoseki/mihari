# frozen_string_literal: true

module Mihari
  module Analyzers
    class HunterHow < Base
      # @return [String, nil]
      attr_reader :api_key

      # @return [Date]
      attr_reader :start_time

      # @return [Date]
      attr_reader :end_time

      #
      # @param [String] query
      # @param [Hash, nil] options
      # @param [String, nil] api_key
      #
      def initialize(query, start_time:, end_time:, options: nil, api_key: nil)
        super(query, options: options)

        @api_key = api_key || Mihari.config.hunterhow_api_key

        @start_time = start_time
        @end_time = end_time
      end

      #
      # @return [Array<Mihari::Artifact>]
      #
      def artifacts
        client.search_with_pagination(
          query,
          start_time: start_time.strftime("%Y-%m-%d"),
          end_time: end_time.strftime("%Y-%m-%d")
        ).map do |res|
          res.data.artifacts
        end.flatten
      end

      def configuration_keys
        %w[hunterhow_api_key]
      end

      private

      def client
        @client ||= Clients::HunterHow.new(api_key: api_key, interval: interval, timeout: timeout)
      end
    end
  end
end
