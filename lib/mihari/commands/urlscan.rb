# frozen_string_literal: true

module Mihari
  module Commands
    module Urlscan
      def self.included(thor)
        thor.class_eval do
          desc "urlscan [QUERY]", "urlscan search"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          method_option :allowed_data_types, type: :array, default: ["url", "ip", "domain"], desc: "types to fetch from search results ('url', 'domain' or 'ip')"
          def urlscan(query)
            with_error_handling do
              run_analyzer Analyzers::Urlscan, query: query, options: options
            end
          end
        end
      end
    end
  end
end
