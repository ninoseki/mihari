# frozen_string_literal: true

module Mihari
  module Entities
    class ReverseDnsName < Grape::Entity
      expose :name, documentation: { type: String, required: true }
    end
  end
end
