module Mihari
  module Commands
    module Onyphe
      def self.included(thor)
        thor.class_eval do
          desc "onyphe [QUERY]", "Onyphe datascan search by a query"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          def onyphe(query)
            with_error_handling do
              run_analyzer Analyzers::Onyphe, query: query, options: options
            end
          end
        end
      end
    end
  end
end
