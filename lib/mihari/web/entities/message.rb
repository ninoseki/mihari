# frozen_string_literal: true

module Mihari
  module Entities
    class Message < Grape::Entity
      expose :message, documentation: { type: String }
    end
  end
end
