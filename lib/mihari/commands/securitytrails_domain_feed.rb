# frozen_string_literal: true

module Mihari
  module Commands
    module SecurityTrailsDomainFeed
      def self.included(thor)
        thor.class_eval do
          desc "securitytrails_domain_feed [REGEXP]", "SecurityTrails new domain feed search by a regexp"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          method_option :type, type: :string, default: "registered", desc: "A type of domain feed ('all', 'new' or 'registered')"
          def securitytrails_domain_feed(regexp)
            with_error_handling do
              run_analyzer Analyzers::SecurityTrailsDomainFeed, query: regexp, options: options
            end
          end
          map "st_domain_feed" => :securitytrails_domain_feedd
        end
      end
    end
  end
end
