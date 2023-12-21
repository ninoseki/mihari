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
            include Dry::Monads[:result, :try]
            include Mixins

            desc "list", "List/search tags"
            around :with_db_connection
            method_option :page, type: :numeric, default: 1
            method_option :limit, type: :numeric, default: 10
            #
            # @param [String] q
            #
            def list(q = "")
              filter = Structs::Filters::Search.new(q: q, page: options["page"], limit: options["limit"])
              result = Services::TagSearcher.result(filter)
              value = result.value!
              data = Entities::TagsWithPagination.represent(
                results: value.results,
                total: value.total,
                current_page: value.filter[:page].to_i,
                page_size: value.filter[:limit].to_i
              )
              puts JSON.pretty_generate(data.as_json)
            end

            desc "delete [ID]", "Delete a tag"
            around :with_db_connection
            #
            # @param [Integer] id
            #
            def delete(id)
              result = Services::TagDestroyer.result(id)
              result.value!
            end
          end
        end
      end
    end
  end
end
