# frozen_string_literal: true

module Mihari
  module Analyzers
    #
    # urlscan.io analyzer
    #
    class Urlscan < Base
      SUPPORTED_DATA_TYPES = %w[url domain ip].freeze

      # @return [String, nil]
      attr_reader :api_key

      # @return [Array<String>]
      attr_reader :data_types

      #
      # @param [String] query
      # @param [Hash, nil] options
      # @param [String, nil] api_key
      # @param [Array<String>] data_types
      #
      def initialize(query, options: nil, api_key: nil, data_types: SUPPORTED_DATA_TYPES)
        super(query, options:)

        @api_key = api_key || Mihari.config.urlscan_api_key
        @data_types = data_types

        return if valid_data_types?

        raise ValueError, "data_types should be any of url, domain and ip."
      end

      def artifacts
        # @type [Array<Mihari::Models::Artifact>]
        artifacts = client.search_with_pagination(query, pagination_limit:).map(&:artifacts).flatten
        artifacts.select { |artifact| data_types.include? artifact.data_type }
      end

      private

      def client
        Clients::Urlscan.new(
          api_key:,
          pagination_interval:,
          timeout:
        )
      end

      #
      # Check whether a data type is valid or not
      #
      # @return [Boolean]
      #
      def valid_data_types?
        data_types.all? { |type| SUPPORTED_DATA_TYPES.include? type }
      end
    end
  end
end
