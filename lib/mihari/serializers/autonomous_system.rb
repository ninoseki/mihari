require "active_model_serializers"

module Mihari
  module Serializers
    class AutonomousSystemSerializer < ActiveModel::Serializer
      attributes :asn
    end
  end
end
