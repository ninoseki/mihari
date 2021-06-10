# frozen_string_literal: true

module Mihari
  module Commands
    module ReverseWhois
      def self.included(thor)
        thor.class_eval do
          desc "reverse_whois [EMAIL]", "Cross search with reverse whois services by an email"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          def reverse_whois(query)
            with_error_handling do
              run_analyzer Analyzers::ReveseWhois, query: query, options: options
            end
          end
        end
      end
    end
  end
end
