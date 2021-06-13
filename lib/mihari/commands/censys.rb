# frozen_string_literal: true

module Mihari
  module Commands
    module Censys
      def self.included(thor)
        thor.class_eval do
          desc "censys [QUERY]", "Censys IPv4 search"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          method_option :type, type: :string, desc: "type to search (ipv4 / websites / certificates)", default: "ipv4"
          def censys(query)
            with_error_handling do
              run_analyzer Analyzers::Censys, query: query, options: options
            end
          end
        end
      end
    end
  end
end
