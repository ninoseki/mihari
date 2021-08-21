# frozen_string_literal: true

require "active_model_serializers"

module Mihari
  module Serializers
    class TagSerializer < ActiveModel::Serializer
      attributes :id, :name
    end
  end
end
