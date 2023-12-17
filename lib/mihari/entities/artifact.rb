# frozen_string_literal: true

module Mihari
  module Entities
    class BaseArtifact < Grape::Entity
      expose :id,
        documentation: { type: String, required: true,
                         desc: "String representation of the ID" } do |artifact, _options|
        artifact.id.to_s
      end
      expose :data, documentation: { type: String, required: true }
      expose :data_type, documentation: { type: String, required: true }, as: :dataType
      expose :source, documentation: { type: String, required: true }
      expose :query, documentation: { type: String, required: false }
    end

    class Artifact < BaseArtifact
      # NOTE: do not define metadata in BaseArtifact since metadata can be relatively big
      expose :metadata, documentation: { type: Hash }
      expose :tags, using: Entities::Tag, documentation: { type: Entities::Tag, is_array: true, required: true }

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
    end

    class ArtifactsWithPagination < Grape::Entity
      expose :artifacts, using: Entities::BaseArtifact,
        documentation: { type: Entities::Artifact, is_array: true, required: true }
      expose :total, documentation: { type: Integer, required: true }
      expose :current_page, documentation: { type: Integer, required: true }, as: :currentPage
      expose :page_size, documentation: { type: Integer, required: true }, as: :pageSize
    end
  end
end
