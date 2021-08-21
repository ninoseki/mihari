# frozen_string_literal: true

require "active_model_serializers"

module Mihari
  module Serializers
    class WhoisRecordSerializer < ActiveModel::Serializer
      attributes :text, :registrar, :created_on
    end
  end
end
