# frozen_string_literal: true

module Mihari
  module Entities
    class Rule < Grape::Entity
      expose :id, documentation: { type: String, required: true }
      expose :title, documentation: { type: String, required: true }
      expose :description, documentation: { type: String, required: true }
      expose :yaml, documentation: { type: String, required: true }
      expose :created_at, documentation: { type: DateTime, required: true }, as: :createdAt
      expose :updated_at, documentation: { type: DateTime, required: true }, as: :updatedAt
      expose :tags, using: Entities::Tag, documentation: { type: Entities::Tag, is_array: true, required: true }
    end

    class RulesWithPagination < Grape::Entity
      expose :rules, using: Entities::Rule, documentation: { type: Entities::Rule, is_array: true, required: true }
      expose :total, documentation: { type: Integer, required: true }
      expose :current_page, documentation: { type: Integer, required: true }, as: :currentPage
      expose :page_size, documentation: { type: Integer, required: true }, as: :pageSize
    end
  end
end
