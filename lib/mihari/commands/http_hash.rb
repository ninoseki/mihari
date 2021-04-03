# frozen_string_literal: true

module Mihari
  module Commands
    module HTTPHash
      def self.included(thor)
        thor.class_eval do
          desc "http_hash", "Cross search with search engines by a hash of an HTTP response (SHA256, MD5 and MurmurHash3)"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          method_option :md5, type: :string, desc: "MD5 hash"
          method_option :sha256, type: :string, desc: "SHA256 hash"
          method_option :mmh3, type: :numeric, desc: "MurmurHash3 hash"
          method_option :html, type: :string, desc: "path to an HTML file"
          def http_hash
            with_error_handling do
              run_analyzer Analyzers::HTTPHash, query: nil, options: options
            end
          end
        end
      end
    end
  end
end
