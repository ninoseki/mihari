# frozen_string_literal: true

require "active_model_serializers"

module Mihari
  class TagSerializer < ActiveModel::Serializer
    attributes :id, :name
  end
end
