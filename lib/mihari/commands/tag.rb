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

            desc "list", "List tags"
            around :with_db_connection
            def list
              tags = Mihari::Models::Tag.all
              data = Entities::Tags.represent({tags: tags})
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
