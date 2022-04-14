# frozen_string_literal: true

module Mihari
  module Entities
    class Port < Grape::Entity
      expose :port, documentation: { type: Integer, required: true }
    end
  end
end
