# frozen_string_literal: true

module Mihari
  module Entities
    class CPE < Grape::Entity
      expose :cpe, documentation: { type: String, required: true }
      expose :created_at, documentation: { type: DateTime, required: true }, as: :createdAt
    end
  end
end
