# frozen_string_literal: true

module Mihari
  module Entities
    class Message < Grape::Entity
      expose :message, documentation: {type: String, required: true}
    end

    class ErrorMessage < Message
      expose :detail, documentation: {type: Hash, required: false}
    end

    class QueueMessage < Message
      expose :queued, documentation: {type: Grape::API::Boolean, required: true}
    end
  end
end
