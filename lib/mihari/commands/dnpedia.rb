# frozen_string_literal: true

module Mihari
  module Commands
    module DNPedia
      def self.included(thor)
        thor.class_eval do
          desc "dnpedia [QUERY]", "DNPedia domain search"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          def dnpedia(query)
            with_error_handling do
              run_analyzer Analyzers::DNPedia, query: query, options: options
            end
          end
        end
      end
    end
  end
end
