# frozen_string_literal: true

module Mihari
  module Commands
    module Crtsh
      def self.included(thor)
        thor.class_eval do
          desc "crtsh [QUERY]", "crt.sh search"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          method_option :exclude_expired, type: :boolean, desc: "exclude expired certificates"
          def crtsh(query)
            with_error_handling do
              run_analyzer Analyzers::Crtsh, query: query, options: options
            end
          end
        end
      end
    end
  end
end
