# frozen_string_literal: true

module Mihari
  module Commands
    module CIRCL
      def self.included(thor)
        thor.class_eval do
          desc "circl [DOMAIN|SHA1]", "CIRCL passive DNS/SSL lookup by a domain or SHA1 certificate fingerprint"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          def circl(query)
            with_error_handling do
              run_analyzer Analyzers::CIRCL, query: query, options: options
            end
          end
        end
      end
    end
  end
end
