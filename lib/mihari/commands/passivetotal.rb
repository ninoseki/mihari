# frozen_string_literal: true

module Mihari
  module Commands
    module PassiveTotal
      def self.included(thor)
        thor.class_eval do
          desc "passivetotal [IP|DOMAIN|EMAIL|SHA1]", "PassiveTotal search by an ip, domain, email or SHA1 certificate fingerprint"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          def passivetotal(indicator)
            with_error_handling do
              run_analyzer Analyzers::PassiveTotal, query: indicator, options: options
            end
          end
        end
      end
    end
  end
end
