# frozen_string_literal: true

module Mihari
  module Commands
    module GreyNoise
      def self.included(thor)
        thor.class_eval do
          desc "greynoise [QUERY]", "GreyNoise search"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          def greynoise(query)
            with_error_handling do
              run_analyzer Analyzers::GreyNoise, query: query, options: options
            end
          end
        end
      end
    end
  end
end
