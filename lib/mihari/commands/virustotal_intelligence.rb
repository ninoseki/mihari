# frozen_string_literal: true

module Mihari
  module Commands
    module VirusTotalIntelligence
      def self.included(thor)
        thor.class_eval do
          desc "virustotal_intelligence [QUERY]", "VirusTotal Intelligence search"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          def virustotal_intelligence(query)
            with_error_handling do
              run_analyzer Analyzers::VirusTotalIntelligence, query: query, options: options
            end
          end
          map "vt_intel" => :virustotal_intelligence
        end
      end
    end
  end
end
