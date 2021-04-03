# frozen_string_literal: true

module Mihari
  module Commands
    module BinaryEdge
      def self.included(thor)
        thor.class_eval do
          desc "binaryedge [QUERY]", "BinaryEdge host search by a query"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          def binaryedge(query)
            with_error_handling do
              run_analyzer Analyzers::BinaryEdge, query: query, options: options
            end
          end
        end
      end
    end
  end
end
