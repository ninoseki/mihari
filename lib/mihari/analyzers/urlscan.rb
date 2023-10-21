# frozen_string_literal: true

module Mihari
  module Analyzers
    class Urlscan < Base
      SUPPORTED_DATA_TYPES = %w[url domain ip].freeze

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

        raise ValueError, "allowed_data_types should be any of url, domain and ip."
      end

      def artifacts
        # @type [Array<Mihari::Artifact>]
        artifacts = client.search_with_pagination(query, pagination_limit: pagination_limit).map(&:artifacts).flatten

        artifacts.select do |artifact|
          allowed_data_types.include? artifact.data_type
        end
      end

      def configuration_keys
        %w[urlscan_api_key]
      end

      private

      def client
        @client ||= Clients::UrlScan.new(
          api_key: api_key,
          pagination_interval: pagination_interval,
          timeout: timeout
        )
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
