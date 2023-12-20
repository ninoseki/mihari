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

    class RulesWithPagination < Pagination
      expose :rules, using: Entities::Rule, documentation: { type: Entities::Rule, is_array: true, required: true }
    end
  end
end
