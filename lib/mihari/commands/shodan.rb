module Mihari
  module Commands
    module Shodan
      def self.included(thor)
        thor.class_eval do
          desc "shodan [QUERY]", "Shodan host search by a query"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          def shodan(query)
            with_error_handling do
              run_analyzer Analyzers::Shodan, query: query, options: options
            end
          end
        end
      end
    end
  end
end
