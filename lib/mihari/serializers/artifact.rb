# frozen_string_literal: true

require "active_model_serializers"

module Mihari
  module Serializers
    class ArtifactSerializer < ActiveModel::Serializer
      attributes :id, :data, :data_type, :source

      has_one :autonomous_system, serializer: AutonomousSystemSerializer
      has_one :geolocation, serializer: GeolocationSerializer
    end
  end
end
