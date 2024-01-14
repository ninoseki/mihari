# frozen_string_literal: true

module Mihari
  module Entities
    class BaseArtifact < Grape::Entity
      expose :id, documentation: { type: Integer, required: true }
      expose :data, documentation: { type: String, required: true }
      expose :data_type, documentation: { type: String, required: true }, as: :dataType
      expose :source, documentation: { type: String, required: true }
      expose :query, documentation: { type: String, required: false }
      expose :created_at, documentation: { type: DateTime, required: true }, as: :createdAt
      expose :tags, using: Entities::Tag, documentation: { type: Entities::Tag, is_array: true, required: true }
    end

    class Artifact < BaseArtifact
      expose :metadata, documentation: { type: Hash }
      expose :autonomous_system, using: Entities::AutonomousSystem,
        documentation: { type: Entities::AutonomousSystem, required: false }, as: :autonomousSystem
      expose :geolocation, using: Entities::Geolocation, documentation: { type: Entities::Geolocation, required: false }
      expose :whois_record, using: Entities::WhoisRecord,
        documentation: { type: Entities::WhoisRecord, required: false }, as: :whoisRecord

      expose :reverse_dns_names, using: Entities::ReverseDnsName,
        documentation: { type: Entities::ReverseDnsName, is_array: true, required: false }, as: :reverseDnsNames do |status, _options|
        status.reverse_dns_names.empty? ? nil : status.reverse_dns_names
      end
      expose :dns_records, using: Entities::DnsRecord,
        documentation: { type: Entities::DnsRecord, is_array: true, required: false }, as: :dnsRecords do |status, _options|
        status.dns_records.empty? ? nil : status.dns_records
      end
      expose :ceps, using: Entities::CPE, documentation: { type: Entities::CPE, is_array: true, required: false },
        as: :cpes do |status, _options|
        status.cpes.empty? ? nil : status.cpes
      end
      expose :ports, using: Entities::Port, documentation: { type: Entities::Port, is_array: true, required: false },
        as: :ports do |status, _options|
        status.ports.empty? ? nil : status.ports
      end
      expose :vulnerabilities, using: Vulnerability, documentation: { type: Vulnerability, is_array: true, required: false },
        as: :vulnerabilities do |status, _options|
        status.vulnerabilities.empty? ? nil : status.vulnerabilities
      end
    end

    class ArtifactsWithPagination < Pagination
      expose :results, using: Entities::BaseArtifact,
        documentation: { type: Entities::Artifact, is_array: true, required: true }
    end
  end
end
