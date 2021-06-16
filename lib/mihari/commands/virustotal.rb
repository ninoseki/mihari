# frozen_string_literal: true

module Mihari
  module Commands
    module VirusTotal
      def self.included(thor)
        thor.class_eval do
          desc "virustotal [IP|DOMAIN]", "VirusTotal resolutions search by an ip or domain"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          def virustotal(indiactor)
            with_error_handling do
              run_analyzer Analyzers::VirusTotal, query: indiactor, options: options
            end
          end
        end
      end
    end
  end
end
