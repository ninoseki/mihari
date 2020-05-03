# frozen_string_literal: true

require "active_model_serializers"

module Mihari
  class ArtifactSerializer < ActiveModel::Serializer
    attributes :data, :data_type
  end
end
