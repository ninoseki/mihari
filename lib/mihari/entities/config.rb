# frozen_string_literal: true

module Mihari
  module Entities
    class Config < Grape::Entity
      expose :name, documentation: {type: String, required: true}
      expose :type, documentation: {type: String, required: true}
      expose :items, documentation: {type: Hash, is_array: true, required: true}
      expose :configured, documentation: {type: Grape::API::Boolean, required: true}
    end

    class Configs < Grape::Entity
      expose :results, using: Config, documentation: {type: Config, is_array: true, required: true}
    end
  end
end
