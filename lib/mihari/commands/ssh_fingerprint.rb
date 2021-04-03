# frozen_string_literal: true

module Mihari
  module Commands
    module SSHFingerprint
      def self.included(thor)
        thor.class_eval do
          desc "ssh_fingerprint [FINGERPRINT]", "Cross search with search engines by an SSH fingerprint (e.g. dc:14:de:8e:d7:c1:15:43:23:82:25:81:d2:59:e8:c0)"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          def ssh_fingerprint(fingerprint)
            with_error_handling do
              run_analyzer Analyzers::SSHFingerprint, query: fingerprint, options: options
            end
          end
        end
      end
    end
  end
end
