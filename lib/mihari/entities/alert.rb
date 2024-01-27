# frozen_string_literal: true

module Mihari
  module Entities
    class Alert < Grape::Entity
      expose :id, documentation: {type: Integer, required: true}
      expose :rule_id, documentation: {type: String, required: true}, as: :ruleId
      expose :created_at, documentation: {type: DateTime, required: true}, as: :createdAt

      expose :artifacts, using: Entities::BaseArtifact, documentation: {type: Entities::BaseArtifact, is_array: true}
      expose :tags, using: Entities::Tag, documentation: {type: Entities::Tag, is_array: true, required: true}
    end

    class AlertsWithPagination < Pagination
      expose :results, using: Entities::Alert, documentation: {type: Entities::Alert, is_array: true, required: true}
    end
  end
end
