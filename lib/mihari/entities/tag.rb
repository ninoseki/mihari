# frozen_string_literal: true

module Mihari
  module Entities
    class Tag < Grape::Entity
      expose :id, documentation: { type: Integer, required: true }
      expose :name, documentation: { type: String, required: true }
    end

    class Tags < Grape::Entity
      expose :tags, documentation: { type: [String], required: true }
    end
  end
end
