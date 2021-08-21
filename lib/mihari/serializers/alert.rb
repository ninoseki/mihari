# frozen_string_literal: true

require "active_model_serializers"

module Mihari
  module Serializers
    class AlertSerializer < ActiveModel::Serializer
      attributes :id, :title, :description, :source, :created_at

      has_many :artifacts, serializer: ArtifactSerializer
      has_many :tags, through: :taggings, serializer: TagSerializer
    end
  end
end
