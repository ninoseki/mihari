# frozen_string_literal: true

module Mihari
  module Entities
    class Pagination < Grape::Entity
      expose :total, documentation: { type: Integer, required: true }
      expose :current_page, documentation: { type: Integer, required: true }, as: :currentPage
      expose :page_size, documentation: { type: Integer, required: true }, as: :pageSize
    end
  end
end
