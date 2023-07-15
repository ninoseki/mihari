# frozen_string_literal: true

require "mihari/feed/reader"
require "mihari/feed/parser"

module Mihari
  module Analyzers
    class Feed < Base
      # @return [Hash, nil]
      attr_reader :data

      # @return [Hash, nil]
      attr_reader :json

      # @return [Hash, nil]
      attr_reader :params

      # @return [Hash, nil]
      attr_reader :headers

      # @return [String]
      attr_reader :method

      # @return [String]
      attr_reader :selector

      # @return [String]
      attr_reader :query

      #
      # @param [String] query
      # @param [Hash, nil] options
      # @param [String] method
      # @param [Hash] headers
      # @param [Hash] params
      # @param [Hash] json
      # @param [Hash] data
      # @param [String] selector
      #
      def initialize(query, options: nil, method: "GET", headers: {}, params: {}, json: {}, data: {}, selector: "")
        super(query, options: options)

        @method = method
        @headers = headers
        @params = params
        @json = json
        @data = data
        @selector = selector
      end

      def artifacts
        Mihari::Feed::Parser.new(results).parse selector
      end

      private

      def results
        reader = Mihari::Feed::Reader.new(
          query,
          method: method,
          headers: headers,
          params: params,
          json: json,
          data: data
        )
        reader.read
      end
    end
  end
end
