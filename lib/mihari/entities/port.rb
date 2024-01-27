# frozen_string_literal: true

module Mihari
  module Entities
    class Port < Grape::Entity
      expose :number, documentation: {type: Integer, required: true}
      expose :created_at, documentation: {type: DateTime, required: true}, as: :createdAt
    end
  end
end
