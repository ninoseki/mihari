# frozen_string_literal: true

module Mihari
  module Entities
    class Config < Grape::Entity
      expose :name, documentation: { type: String, required: true }
      expose :type, documentation: { type: String, required: true }
      expose :values, documentation: { type: String, is_array: true, required: true }
      expose :is_configured, documentation: { type: Grape::API::Boolean, required: true }, as: :isConfigured
    end
  end
end
