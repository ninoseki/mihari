# frozen_string_literal: true

require "mihari/feed/reader"
require "mihari/feed/parser"

module Mihari
  module Analyzers
    class Feed < Base
      param :query

      option :method, default: proc { "GET" }
      option :headers, default: proc { {} }
      option :params, default: proc {}
      option :json, default: proc {}
      option :data, default: proc {}

      option :selector, default: proc { "" }

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
