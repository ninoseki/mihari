# frozen_string_literal: true

module Mihari
  module Entities
    class Query < Grape::Entity
      expose :analyzer, documentation: { type: String, required: true }
      expose :query, documentation: { type: String, required: true }
      expose :interval, documentation: { type: Integer, required: false }
    end

    class Emitter < Grape::Entity
      expose :emitter, documentation: { type: String, required: true }
    end

    class Rule < Grape::Entity
      expose :id, documentation: { type: String, required: true }
      expose :yaml, documentation: { type: String, required: true }
      expose :created_at, documentation: { type: DateTime, required: true }, as: :createdAt
      expose :updated_at, documentation: { type: DateTime, required: true }, as: :updatedAt
    end

    class RulesWithPagination < Grape::Entity
      expose :rules, using: Entities::Rule, documentation: { type: Entities::Rule, is_array: true, required: true }
      expose :total, documentation: { type: Integer, required: true }
      expose :current_page, documentation: { type: Integer, required: true }, as: :currentPage
      expose :page_size, documentation: { type: Integer, required: true }, as: :pageSize
    end

    class RuleIDs < Grape::Entity
      expose :rule_ids, documentation: { type: Array[String], required: true }
    end
  end
end
