# frozen_string_literal: true

module Mihari
  module Commands
    module Feed
      def self.included(thor)
        thor.class_eval do
          desc "feed [URL]", "ingest feed"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          method_option :http_request_method, type: :string, desc: "HTTP request method"
          method_option :http_request_headers, type: :hash, desc: "HTTP request headers"
          method_option :http_request_payload_type, type: :string, desc: "HTTP request payload type"
          method_option :http_request_payload, type: :hash, desc: "HTTP request payload"
          method_option :selector, type: :string, desc: "jr selector", required: true
          def feed(query)
            with_error_handling do
              run_analyzer Analyzers::Feed, query: query, options: options
            end
          end
        end
      end
    end
  end
end
