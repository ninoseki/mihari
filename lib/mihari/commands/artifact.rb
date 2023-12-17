# frozen_string_literal: true

module Mihari
  module Commands
    #
    # Artifact sub-commands
    #
    module Artifact
      class << self
        def included(thor)
          thor.class_eval do
            include Mixins

            desc "search", "Search artifacts"
            around :with_db_connection
            method_option :page, type: :numeric, default: 1
            method_option :limit, type: :numeric, default: 10
            #
            # @param [String] q
            #
            def search(q = "")
              filter = Structs::Filters::Search.new(q: q, page: options["page"], limit: options["limit"])
              result = Services::ArtifactSearcher.result(filter)
              value = result.value!
              data = Entities::ArtifactsWithPagination.represent(
                artifacts: value.results,
                total: value.total,
                current_page: value.filter[:page].to_i,
                page_size: value.filter[:limit].to_i
              )
              puts JSON.pretty_generate(data.as_json)
            end
          end
        end
      end
    end
  end
end
