# frozen_string_literal: true

module Mihari
  module Analyzers
    class Urlscan < Base
      param :query

      option :allowed_data_types, default: proc { SUPPORTED_DATA_TYPES }

      option :interval, default: proc { 0 }

      SUPPORTED_DATA_TYPES = %w[url domain ip].freeze
      SIZE = 1000

      # @return [String, nil]
      attr_reader :api_key

      # @return [String]
      attr_reader :query

      # @return [Integer]
      attr_reader :interval

      # @return [String]
      attr_reader :allowed_data_types

      def initialize(*args, **kwargs)
        super

        unless valid_allowed_data_types?
          raise InvalidInputError, "allowed_data_types should be any of url, domain and ip."
        end

        @api_key = kwargs[:api_key] || Mihari.config.urlscan_api_key
      end

      def artifacts
        responses = search
        results = responses.map(&:results).flatten

        allowed_data_types.map do |type|
          results.filter_map do |result|
            page = result.page
            data = page.send(type.to_sym)
            data.nil? ? nil : Artifact.new(data: data, source: source, metadata: result)
          end
        end.flatten
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
          sleep interval
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
