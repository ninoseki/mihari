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
            include Concerns::DatabaseConnectable

            no_commands do
              #
              # @param [String] q
              # @param [Integer] page
              # @param [Integer] limit
              #
              # @return [Mihari::Services::ResultValue]
              #
              def _search(q, page: 1, limit: 10)
                filter = Structs::Filters::Search.new(q:, page:, limit:)
                Services::ArtifactSearcher.call filter
              end
            end

            desc "list QUERY", "List/search artifacts"
            around :with_db_connection
            method_option :page, type: :numeric, default: 1
            method_option :limit, type: :numeric, default: 10
            #
            # @param [String] q
            #
            def list(q = "")
              value = _search(q, page: options["page"], limit: options["limit"])
              data = Entities::ArtifactsWithPagination.represent(
                results: value.results,
                total: value.total,
                current_page: value.filter[:page].to_i,
                page_size: value.filter[:limit].to_i
              )
              puts JSON.pretty_generate(data.as_json)
            end

            desc "list-transform QUERY", "List/search artifacts with transformation"
            around :with_db_connection
            method_option :template, type: :string, required: true, aliases: "-t",
              desc: "Jbuilder template stringor a path to a template"
            method_option :page, type: :numeric, default: 1
            method_option :limit, type: :numeric, default: 10
            #
            # @param [String] q
            #
            def list_transform(q = "")
              value = _search(q, page: options["page"], limit: options["limit"])
              puts Services::JbuilderRenderer.call(
                options["template"],
                {
                  results: value.results,
                  total: value.total,
                  current_page: value.filter[:page].to_i,
                  page_size: value.filter[:limit].to_i
                }
              )
            end

            desc "get ID", "Get an artifact"
            around :with_db_connection
            #
            # @param [Integer] id
            #
            def get(id)
              value = Services::ArtifactGetter.result(id).value!
              data = Entities::Artifact.represent(value)
              puts JSON.pretty_generate(data.as_json)
            end

            desc "enrich ID", "Enrich an artifact"
            around :with_db_connection
            #
            # @param [Integer] id
            #
            def enrich(id)
              Services::ArtifactEnricher.call id
            end

            desc "delete ID", "Delete an artifact"
            around :with_db_connection
            #
            # @param [Integer] id
            #
            def delete(id)
              Services::ArtifactDestroyer.call id
            end
          end
        end
      end
    end
  end
end
