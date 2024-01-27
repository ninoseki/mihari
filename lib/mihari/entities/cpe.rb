# frozen_string_literal: true

module Mihari
  module Entities
    class CPE < Grape::Entity
      expose :name, documentation: {type: String, required: true}
      expose :created_at, documentation: {type: DateTime, required: true}, as: :createdAt
    end
  end
end
