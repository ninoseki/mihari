# frozen_string_literal: true

module Mihari
  module Commands
    module PassiveSSL
      def self.included(thor)
        thor.class_eval do
          desc "passive_ssl [SHA1]", "Cross search with passive SSL services by an SHA1 certificate fingerprint"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          def passive_ssl(query)
            with_error_handling do
              run_analyzer Analyzers::PassiveSSL, query: query, options: options
            end
          end
        end
      end
    end
  end
end
