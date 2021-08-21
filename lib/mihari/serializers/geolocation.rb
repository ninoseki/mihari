# frozen_string_literal: true

require "active_model_serializers"

module Mihari
  module Serializers
    class GeolocationSerializer < ActiveModel::Serializer
      attributes :country, :country_code
    end
  end
end
