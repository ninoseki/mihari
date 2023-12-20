# frozen_string_literal: true

module Mihari
  module Entities
    class Alert < Grape::Entity
      expose :id,
        documentation: { type: String, required: true,
                         desc: "String representation of the ID" } do |alert, _options|
        alert.id.to_s
      end
      expose :rule_id, documentation: { type: String, required: true }, as: :ruleId
      expose :created_at, documentation: { type: DateTime, required: true }, as: :createdAt

      expose :artifacts, using: Entities::BaseArtifact, documentation: { type: Entities::BaseArtifact, is_array: true }
      expose :tags, using: Entities::Tag, documentation: { type: Entities::Tag, is_array: true, required: true }
    end

    class AlertsWithPagination < Pagination
      expose :alerts, using: Entities::Alert, documentation: { type: Entities::Alert, is_array: true, required: true }
    end
  end
end
