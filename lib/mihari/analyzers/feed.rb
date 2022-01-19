# frozen_string_literal: true

require "mihari/feed/reader"
require "mihari/feed/parser"

module Mihari
  module Analyzers
    class Feed < Base
      param :query

      option :http_request_method, default: proc { "GET" }
      option :http_request_headers, default: proc { {} }
      option :http_request_payload, default: proc { {} }
      option :http_request_payload_type, default: proc {}

      option :selector, default: proc { "" }

      def artifacts
        Mihari::Feed::Parser.new(data).parse selector
      end

      private

      def data
        reader = Mihari::Feed::Reader.new(
          query,
          http_request_method: http_request_method,
          http_request_headers: http_request_headers,
          http_request_payload: http_request_payload,
          http_request_payload_type: http_request_payload_type
        )
        reader.read
      end
    end
  end
end
