# frozen_string_literal: true

module Mihari
  module Entities
    class Sources < Grape::Entity
      expose :sources, documentation: { type: Array[String], required: true }
    end
  end
end
