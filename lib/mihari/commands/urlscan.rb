# frozen_string_literal: true

module Mihari
  module Commands
    module Urlscan
      def self.included(thor)
        thor.class_eval do
          desc "urlscan [QUERY]", "urlscan search by a given query"
          method_option :title, type: :string, desc: "title"
          method_option :description, type: :string, desc: "description"
          method_option :tags, type: :array, desc: "tags"
          method_option :filter, type: :string, desc: "filter for urlscan pro search"
          method_option :target_type, type: :string, default: "url", desc: "target type to fetch from lookup results (target type should be 'url', 'domain' or 'ip')"
          method_option :use_pro, type: :boolean, default: false, desc: "use pro search API or not"
          method_option :use_similarity, type: :boolean, default: false, desc: "use similarity API or not"
          def urlscan(query)
            with_error_handling do
              run_analyzer Analyzers::Urlscan, query: query, options: options
            end
          end
        end
      end
    end
  end
end
