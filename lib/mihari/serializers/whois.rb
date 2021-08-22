# frozen_string_literal: true

require "active_model_serializers"

module Mihari
  module Serializers
    class WhoisRecordSerializer < ActiveModel::Serializer
      attributes :domain, :created_on, :updated_on, :expires_on, :registrar, :contacts
    end
  end
end
