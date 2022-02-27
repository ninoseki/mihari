# frozen_string_literal: true

module Mihari
  module Entities
    class Alert < Grape::Entity
      expose :id, documentation: { type: Integer, required: true }
      expose :title, documentation: { type: String, required: true }
      expose :description, documentation: { type: String, required: true }
      expose :source, documentation: { type: String, required: true }
      expose :created_at, documentation: { type: DateTime, required: true }, as: :createdAt

      expose :artifacts, using: Entities::Artifact, documentation: { type: Entities::Artifact, is_array: true }
      expose :tags, using: Entities::Tag, documentation: { type: Entities::Tag, is_array: true, required: true }
    end

    class AlertsWithPagination < Grape::Entity
      expose :alerts, using: Entities::Alert, documentation: { type: Entities::Alert, is_array: true, required: true }
      expose :total, documentation: { type: Integer, required: true }
      expose :current_page, documentation: { type: Integer, required: true }, as: :currentPage
      expose :page_size, documentation: { type: Integer, required: true }, as: :pageSize
    end
  end
end
