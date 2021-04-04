# frozen_string_literal: true

module Mihari
  module Commands
    module DNSTwister
      def self.included(thor)
        thor.class_eval do
          desc "dnstwister [DOMAIN]", "dnstwister lookup by a domain"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          def dnstwister(domain)
            with_error_handling do
              run_analyzer Analyzers::DNSTwister, query: refang(domain), options: options
            end
          end
        end
      end
    end
  end
end
