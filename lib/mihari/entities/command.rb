# frozen_string_literal: true

module Mihari
  module Entities
    class CommandInput < Grape::Entity
      expose :command, documentation: { type: String, required: true }
    end

    class CommandResult < Grape::Entity
      expose :output, documentation: { type: String, required: true }
      expose :success, documentation: { type: Grape::API::Boolean, required: true }
    end
  end
end
