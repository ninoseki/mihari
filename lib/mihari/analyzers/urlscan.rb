# frozen_string_literal: true

module Mihari
  module Analyzers
    class Urlscan < Base
      SUPPORTED_DATA_TYPES = %w[url domain ip].freeze
      SIZE = 1000

      # @return [String, nil]
      attr_reader :api_key

      # @return [Array<String>]
      attr_reader :allowed_data_types

      #
      # @param [String] query
      # @param [Hash, nil] options
      # @param [String, nil] api_key
      # @param [Array<String>] allowed_data_types
      #
      def initialize(query, options: nil, api_key: nil, allowed_data_types: SUPPORTED_DATA_TYPES)
        super(query, options: options)

        @api_key = api_key || Mihari.config.urlscan_api_key
        @allowed_data_types = allowed_data_types

        return if valid_allowed_data_types?

        raise InvalidInputError, "allowed_data_types should be any of url, domain and ip."
      end

      def artifacts
        responses = search
        # @type [Array<Mihari::Artifact>]
        artifacts = responses.map { |res| res.to_artifacts }.flatten

        artifacts.select do |artifact|
          allowed_data_types.include? artifact.data_type
        end
      end

      private

      def configuration_keys
        %w[urlscan_api_key]
      end

      def client
        @client ||= Clients::UrlScan.new(api_key: api_key)
      end

      #
      # Search with search_after option
      #
      # @return [Structs::Urlscan::Response]
      #
      def search_with_search_after(search_after: nil)
        res = client.search(query, size: SIZE, search_after: search_after)
        Structs::Urlscan::Response.from_dynamic! res
      end

      #
      # Search
      #
      # @return [Array<Structs::Urlscan::Response>]
      #
      def search
        responses = []

        search_after = nil
        loop do
          res = search_with_search_after(search_after: search_after)
          responses << res

          break if res.results.length < SIZE

          search_after = res.results.last.sort.join(",")

          # sleep #{interval} seconds to avoid the rate limitation (if it is set)
          sleep_interval
        end

        responses
      end

      #
      # Check whether a data type is valid or not
      #
      # @return [Boolean]
      #
      def valid_allowed_data_types?
        allowed_data_types.all? { |type| SUPPORTED_DATA_TYPES.include? type }
      end
    end
  end
end
