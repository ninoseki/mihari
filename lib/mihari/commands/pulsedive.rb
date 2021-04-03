# frozen_string_literal: true

module Mihari
  module Commands
    module Pulsedive
      def self.included(thor)
        thor.class_eval do
          desc "pulsedive [IP|DOMAIN]", "Pulsedive lookup by an ip or domain"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          def pulsedive(indiactor)
            with_error_handling do
              run_analyzer Analyzers::Pulsedive, query: refang(indiactor), options: options
            end
          end
        end
      end
    end
  end
end
