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
        artifacts = []

        (1..pagination_limit).each do |page|
          res = client.search(
            query,
            page: page,
            page_size: PAGE_SIZE,
            start_time: start_time.strftime("%Y-%m-%d"),
            end_time: end_time.strftime("%Y-%m-%d")
          )

          artifacts << res.data.artifacts

          break if res.data.list.length < PAGE_SIZE

          sleep_interval
        end

        artifacts.flatten
      end

      def configuration_keys
        %w[hunterhow_api_key]
      end

      private

      # @return [Integer]
      PAGE_SIZE = 100

      def client
        @client ||= Clients::HunterHow.new(api_key: api_key)
      end
    end
  end
end
