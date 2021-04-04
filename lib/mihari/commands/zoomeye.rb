# frozen_string_literal: true

module Mihari
  module Commands
    module ZoomEye
      def self.included(thor)
        thor.class_eval do
          desc "zoomeye [QUERY]", "ZoomEye search by a query"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          method_option :type, type: :string, desc: "type to search(host / web)", default: "host"
          def zoomeye(query)
            with_error_handling do
              run_analyzer Analyzers::ZoomEye, query: query, options: options
            end
          end
        end
      end
    end
  end
end
