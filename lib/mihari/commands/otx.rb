# frozen_string_literal: true

module Mihari
  module Commands
    module OTX
      def self.included(thor)
        thor.class_eval do
          desc "otx [IP|DOMAIN]", "OTX lookup by an IP or domain"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          def otx(domain)
            with_error_handling do
              run_analyzer Analyzers::OTX, query: refang(domain), options: options
            end
          end
        end
      end
    end
  end
end
