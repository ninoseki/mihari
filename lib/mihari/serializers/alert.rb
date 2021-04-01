# frozen_string_literal: true

require "active_model_serializers"

module Mihari
  class AlertSerializer < ActiveModel::Serializer
    attributes :id, :title, :description, :source, :created_at

    has_many :artifacts
    has_many :tags, through: :taggings
  end
end
