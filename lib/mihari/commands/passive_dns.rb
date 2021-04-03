module Mihari
  module Commands
    module PassiveDNS
      def self.included(thor)
        thor.class_eval do
          desc "passive_dns [IP|DOMAIN]", "Cross search with passive DNS services by an ip or domain"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          def passive_dns(query)
            with_error_handling do
              run_analyzer Analyzers::PassiveDNS, query: refang(query), options: options
            end
          end
        end
      end
    end
  end
end
