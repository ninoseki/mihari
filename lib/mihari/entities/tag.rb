# frozen_string_literal: true

module Mihari
  module Entities
    class Tag < Grape::Entity
      expose :id, documentation: {type: Integer, required: true}
      expose :name, documentation: {type: String, required: true}
    end

    class TagsWithPagination < Pagination
      expose :results, using: Entities::Tag, documentation: {type: Entities::Tag, is_array: true, required: true}
    end
  end
end
