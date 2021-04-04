# frozen_string_literal: true

module Mihari
  module Commands
    module SecurityTrails
      def self.included(thor)
        thor.class_eval do
          desc "securitytrails [IP|DOMAIN|EMAIL]", "SecurityTrails lookup by an ip, domain or email"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          def securitytrails(indiactor)
            with_error_handling do
              run_analyzer Analyzers::SecurityTrails, query: refang(indiactor), options: options
            end
          end
          map "st" => :securitytrails
        end
      end
    end
  end
end
