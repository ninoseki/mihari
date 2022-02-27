# frozen_string_literal: true

module Mihari
  module Entities
    class Query < Grape::Entity
      expose :analyzer, documentation: { type: String, required: true }
      expose :query, documentation: { type: String, required: true }
      expose :interval, documentation: { type: Integer, required: false }
    end

    class Rule < Grape::Entity
      expose :id, documentation: { type: String, required: true }

      expose :yaml, documentation: { type: String, required: true }

      expose :title, documentation: { type: String, required: true }
      expose :description, documentation: { type: String, required: true }
      expose :queries, using: Entities::Query, documentation: { type: Entities::Query, is_array: true, required: true }
      expose :tags, documentation: { type: String, is_array: true }
      expose :allowed_data_types, documentation: { type: String, is_array: true }, as: :allowedDtaTypes
      expose :disallowed_data_values, documentation: { type: String, is_array: true }, as: :disallowedDataValues
      expose :ignore_old_artifacts, documentation: { type: "boolean", required: true }, as: :ignoreOldArtifacts
      expose :ignore_threshold, documentation: { type: Integer, required: true }, as: :ignoreThreshold

      expose :created_at, documentation: { type: DateTime, required: true }, as: :createdAt
    end

    class RulesWithPagination < Grape::Entity
      expose :rules, using: Entities::Rule, documentation: { type: Entities::Rule, is_array: true, required: true }
      expose :total, documentation: { type: Integer, required: true }
      expose :current_page, documentation: { type: Integer, required: true }, as: :currentPage
      expose :page_size, documentation: { type: Integer, required: true }, as: :pageSize
    end
  end
end
