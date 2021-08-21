# frozen_string_literal: true

require "active_model_serializers"

module Mihari
  module Serializers
    class ArtifactSerializer < ActiveModel::Serializer
      attributes :id, :data, :data_type, :source

      has_one :autonomous_system, serializer: AutonomousSystemSerializer
      has_one :geolocation, serializer: GeolocationSerializer
      has_one :whois_record, serializer: WhoisRecordSerializer

      has_many :dns_records, serializer: DnsRecordSerializer
    end
  end
end
