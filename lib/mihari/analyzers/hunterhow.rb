# frozen_string_literal: true

module Mihari
  module Analyzers
    #
    # hunter.how analyzer
    #
    class HunterHow < Base
      # @return [String, nil]
      attr_reader :api_key

      # @return [Date]
      attr_reader :start_time

      # @return [Date]
      attr_reader :end_time

      #
      # @param [String] query
      # @param [Date] start_time
      # @param [Date] end_time
      # @param [Hash, nil] options
      # @param [String, nil] api_key
      #
      def initialize(query, start_time: nil, end_time: nil, options: nil, api_key: nil)
        super(query, options:)

        @api_key = api_key || Mihari.config.hunterhow_api_key

        @start_time = start_time
        @end_time = end_time
      end

      #
      # @return [Array<Mihari::Models::Artifact>]
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

      private

      def client
        Clients::HunterHow.new(
          api_key:,
          pagination_interval:,
          timeout:
        )
      end
    end
  end
end
