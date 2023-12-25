# frozen_string_literal: true

module Mihari
  module Entities
    class Message < Grape::Entity
      expose :message, documentation: { type: String, required: true }
    end

    class ErrorMessage < Message
      expose :detail, documentation: { type: Hash, required: false }
    end
  end
end
