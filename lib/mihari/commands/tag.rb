# frozen_string_literal: true

module Mihari
  module Commands
    #
    # Tag sub-commands
    #
    module Tag
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
                filter = Structs::Filters::Search.new(q: q, page: page, limit: limit)
                Services::TagSearcher.result(filter).value!
              end
            end

            desc "list", "List/search tags"
            around :with_db_connection
            method_option :page, type: :numeric, default: 1
            method_option :limit, type: :numeric, default: 10
            #
            # @param [String] q
            #
            def list(q = "")
              value = _search(q, page: options["page"], limit: options["limit"])
              data = Entities::TagsWithPagination.represent(
                results: value.results,
                total: value.total,
                current_page: value.filter[:page].to_i,
                page_size: value.filter[:limit].to_i
              )
              puts JSON.pretty_generate(data.as_json)
            end

            desc "list-transform QUERY", "List/search tags with transformation"
            around :with_db_connection
            method_option :template, type: :string, required: true, aliases: "-t",
              description: "Jbuilder template itself or a path to a template file"
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

            desc "delete [ID]", "Delete a tag"
            around :with_db_connection
            #
            # @param [Integer] id
            #
            def delete(id)
              Services::TagDestroyer.result(id).value!
            end
          end
        end
      end
    end
  end
end
