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
