# frozen_string_literal: true

module Mihari
  module Entities
    class AutonomousSystem < Grape::Entity
      expose :number, documentation: {type: Integer, required: true}
    end
  end
end
