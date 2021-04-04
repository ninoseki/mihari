# frozen_string_literal: true

module Mihari
  module Commands
    module Spyse
      def self.included(thor)
        thor.class_eval do
          desc "spyse [QUERY]", "Spyse search by a query"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          method_option :type, type: :string, desc: "type to search (ip or domain)", default: "doamin"
          def spyse(query)
            with_error_handling do
              run_analyzer Analyzers::Spyse, query: query, options: options
            end
          end
        end
      end
    end
  end
end
