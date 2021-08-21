# frozen_string_literal: true

require "active_model_serializers"

module Mihari
  module Serializers
    class DnsRecordSerializer < ActiveModel::Serializer
      attributes :resource, :value
    end
  end
end
