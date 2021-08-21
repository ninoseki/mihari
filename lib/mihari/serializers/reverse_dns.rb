# frozen_string_literal: true

require "active_model_serializers"

module Mihari
  module Serializers
    class ReverseDnsNameSerializer < ActiveModel::Serializer
      attributes :name
    end
  end
end
