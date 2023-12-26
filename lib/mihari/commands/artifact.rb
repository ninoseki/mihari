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

            desc "list [QUERY]", "List/search artifacts"
            around :with_db_connection
            method_option :page, type: :numeric, default: 1
            method_option :limit, type: :numeric, default: 10
            #
            # @param [String] q
            #
            def list(q = "")
              filter = Structs::Filters::Search.new(q: q, page: options["page"], limit: options["limit"])
              value = Services::ArtifactSearcher.result(filter).value!
              data = Entities::ArtifactsWithPagination.represent(
                results: value.results,
                total: value.total,
                current_page: value.filter[:page].to_i,
                page_size: value.filter[:limit].to_i
              )
              puts JSON.pretty_generate(data.as_json)
            end

            desc "get [ID]", "Get an artifact"
            around :with_db_connection
            #
            # @param [Integer] id
            #
            def get(id)
              value = Services::ArtifactGetter.result(id).value!
              data = Entities::Artifact.represent(value)
              puts JSON.pretty_generate(data.as_json)
            end

            desc "enrich [ID]", "Enrich an artifact"
            around :with_db_connection
            #
            # @param [Integer] id
            #
            def enrich(id)
              Services::ArtifactEnricher.result(id)
            end

            desc "delete [ID]", "Delete an artifact"
            around :with_db_connection
            #
            # @param [Integer] id
            #
            def delete(id)
              Services::ArtifactDestroyer.result(id).value!
            end
          end
        end
      end
    end
  end
end
