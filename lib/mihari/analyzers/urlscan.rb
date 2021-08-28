# frozen_string_literal: true

require "urlscan"

SUPPORTED_DATA_TYPES = %w[url domain ip].freeze

module Mihari
  module Analyzers
    class Urlscan < Base
      param :query
      option :title, default: proc { "urlscan search" }
      option :description, default: proc { "query = #{query}" }
      option :tags, default: proc { [] }
      option :allowed_data_types, default: proc { SUPPORTED_DATA_TYPES }
      option :use_similarity, default: proc { false }

      def initialize(*args, **kwargs)
        super

        raise InvalidInputError, "allowed_data_types should be any of url, domain and ip." unless valid_alllowed_data_types?
      end

      def artifacts
        result = search
        return [] unless result

        results = result["results"] || []

        allowed_data_types.map do |type|
          results.filter_map do |match|
            match.dig "page", type
          end.uniq
        end.flatten
      end

      private

      def configuration_keys
        %w[urlscan_api_key]
      end

      def api
        @api ||= ::UrlScan::API.new(Mihari.config.urlscan_api_key)
      end

      #
      # Search
      #
      # @return [Array<Hash>]
      #
      def search
        return api.pro.similar(query) if use_similarity

        api.search(query, size: 10_000)
      end

      #
      # Check whether a data type is valid or not
      #
      # @return [Boolean]
      #
      def valid_alllowed_data_types?
        allowed_data_types.all? { |type| SUPPORTED_DATA_TYPES.include? type }
      end
    end
  end
end
