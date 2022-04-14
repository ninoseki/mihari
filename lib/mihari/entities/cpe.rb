# frozen_string_literal: true

module Mihari
  module Entities
    class CPE < Grape::Entity
      expose :cpe, documentation: { type: String, required: true }
    end
  end
end
