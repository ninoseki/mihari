# frozen_string_literal: true

module Mihari
  module Commands
    module FreeText
      def self.included(thor)
        thor.class_eval do
          desc "free_text [TEXT]", "Cross search with search engines by a free text"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          def free_text(text)
            with_error_handling do
              run_analyzer Analyzers::FreeText, query: text, options: options
            end
          end
        end
      end
    end
  end
end
