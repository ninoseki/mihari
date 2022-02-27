# frozen_string_literal: true

module Mihari
  module Entities
    class ConfigStatus < Grape::Entity
      expose :type, documentation: { type: String, required: true }
      expose :values, documentation: { type: String, is_array: true, required: true }
      expose :is_configured, documentation: { type: Grape::API::Boolean, required: true }, as: :isConfigured
    end

    class Config < Grape::Entity
      expose :name, documentation: { type: String, required: true }
      expose :status, using: Entities::ConfigStatus, documentation: { type: ConfigStatus, required: true }
    end
  end
end
