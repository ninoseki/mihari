# frozen_string_literal: true

module Mihari
  module Entities
    class Artifact < Grape::Entity
      expose :id, documentation: { type: Integer, required: true }
      expose :data, documentation: { type: String, required: true }
      expose :data_type, documentation: { type: String, required: true }, as: :dataType
      expose :source, documentation: { type: String, required: true }
      expose :tags, documentation: { type: String, is_array: true }

      expose :metadata, documentation: { type: Hash }

      expose :autonomous_system, using: Entities::AutonomousSystem, documentation: { type: Entities::AutonomousSystem, required: false }, as: :autonomousSystem
      expose :geolocation, using: Entities::Geolocation, documentation: { type: Entities::Geolocation, required: false }
      expose :whois_record, using: Entities::WhoisRecord, documentation: { type: Entities::WhoisRecord, required: false }, as: :whoisRecord

      expose :reverse_dns_names, using: Entities::ReverseDnsName, documentation: { type: Entities::ReverseDnsName, is_array: true, required: false }, as: :reverseDnsNames do |status, _options|
        status.reverse_dns_names.empty? ? nil : status.reverse_dns_names
      end
      expose :dns_records, using: Entities::DnsRecord, documentation: { type: Entities::DnsRecord, is_array: true, required: false }, as: :dnsRecords do |status, _options|
        status.dns_records.empty? ? nil : status.dns_records
      end
    end
  end
end
