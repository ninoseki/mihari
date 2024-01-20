# frozen_string_literal: true

module Mihari
  module Models
    #
    # Artifact validator
    #
    class ArtifactValidator < ActiveModel::Validator
      def validate(record)
        return if record.data_type

        record.errors.add :data, "#{record.data} is not supported"
      end
    end

    #
    # Artifact model
    #
    class Artifact < ActiveRecord::Base
      # @!attribute [r] id
      #   @return [Integer, nil]

      # @!attribute [rw] data
      #   @return [String]

      # @!attribute [rw] data_type
      #   @return [String]

      # @!attribute [rw] source
      #   @return [String, nil]

      # @!attribute [rw] query
      #   @return [String, nil]

      # @!attribute [rw] metadata
      #   @return [Hash, nil]

      # @!attribute [rw] created_at
      #   @return [DateTime]

      # @!attribute [r] alert
      #   @return [Mihari::Models::Alert]

      # @!attribute [r] rule
      #   @return [Mihari::Models::Rule]

      # @!attribute [rw] autonomous_system
      #   @return [Mihari::Models::AutonomousSystem, nil]

      # @!attribute [rw] geolocation
      #   @return [Mihari::Models::Geolocation, nil]

      # @!attribute [rw] whois_record
      #   @return [Mihari::Models::WhoisRecord, nil]

      # @!attribute [rw] cpes
      #   @return [Array<Mihari::Models::CPE>]

      # @!attribute [rw] dns_records
      #   @return [Array<Mihari::Models::DnsRecord>]

      # @!attribute [rw] ports
      #   @return [Array<Mihari::Models::Port>]

      # @!attribute [rw] reverse_dns_names
      #   @return [Array<Mihari::Models::ReverseDnsName>]

      # @!attribute [rw] vulnerabilities
      #   @return [Array<Mihari::Models::Vulnerability>]

      # @!attribute [r] alert
      #   @return [Mihari::Models::Alert]

      # @!attribute [r] rule
      #   @return [Mihari::Models::Rule]

      # @!attribute [rw] autonomous_system
      #   @return [Mihari::Models::AutonomousSystem, nil]

      # @!attribute [rw] geolocation
      #   @return [Mihari::Models::Geolocation, nil]

      # @!attribute [rw] whois_record
      #   @return [Mihari::Models::WhoisRecord, nil]

      # @!attribute [rw] cpes
      #   @return [Array<Mihari::Models::CPE>]

      # @!attribute [rw] dns_records
      #   @return [Array<Mihari::Models::DnsRecord>]

      # @!attribute [rw] ports
      #   @return [Array<Mihari::Models::Port>]

      # @!attribute [rw] reverse_dns_names
      #   @return [Array<Mihari::Models::ReverseDnsName>]

      # @!attribute [rw] vulnerabilities
      #   @return [Array<Mihari::Models::Vulnerability>]

      # @!attribute [rw] tags
      #   @return [Array<Mihari::Models::Tag>]

      belongs_to :alert

      has_one :autonomous_system, dependent: :destroy
      has_one :geolocation, dependent: :destroy
      has_one :whois_record, dependent: :destroy
      has_one :rule, through: :alert

      has_many :cpes, dependent: :destroy
      has_many :dns_records, dependent: :destroy
      has_many :ports, dependent: :destroy
      has_many :reverse_dns_names, dependent: :destroy
      has_many :vulnerabilities, dependent: :destroy

      has_many :tags, through: :alert

      include ActiveModel::Validations
      include SearchCop
      include Concerns::Searchable

      search_scope :search do
        attributes :id, :data, :data_type, :source, :query, :created_at, "alert.id", "rule.id", "rule.title",
          "rule.description"
        attributes tag: "tags.name"
        attributes asn: "autonomous_system.number"
        attributes country_code: "geolocation.country_code"
        attributes "dns_record.value": "dns_records.value"
        attributes "dns_record.resource": "dns_records.resource"
        attributes reverse_dns_name: "reverse_dns_names.name"
        attributes cpe: "cpes.name"
        attributes vuln: "vulnerabilities.name"
        attributes port: "ports.number"
      end

      validates_with ArtifactValidator

      after_initialize :set_data_type, :set_rule_id, if: :new_record?

      # @return [String, nil]
      attr_accessor :rule_id

      before_destroy do
        @alert = alert
      end

      after_destroy do
        @alert.destroy unless @alert.artifacts.any?
      end

      #
      # Check uniqueness
      #
      # @param [Time, nil] base_time Base time to check decaying
      # @param [Integer, nil] artifact_ttl Artifact TTL in seconds
      #
      # @return [Boolean] true if it is unique. Otherwise false.
      #
      def unique?(base_time: nil, artifact_ttl: nil)
        artifact = self.class.joins(:alert).where(
          data: data,
          alert: { rule_id: rule_id }
        ).order(created_at: :desc).first
        return true if artifact.nil?

        # check whether the artifact is decayed or not
        return false if artifact_ttl.nil?

        # use the current UTC time if base_time is not given (for testing)
        base_time ||= Time.now.utc

        decayed_at = base_time - (artifact_ttl || -1).seconds
        artifact.created_at < decayed_at
      end

      def enrichable?
        !callable_enrichers.empty?
      end

      def enrich
        callable_enrichers.each { |enricher| enricher.result self }
      end

      #
      # @return [String, nil]
      #
      def domain
        case data_type
        when "domain"
          data
        when "url"
          host = Addressable::URI.parse(data).host
          (DataType.type(host) == "ip") ? nil : host
        end
      end

      class << self
        # @!method search_by_filter(filter)
        #   @param [Mihari::Structs::Filters::Search] filter
        #   @return [Array<Mihari::Models::Alert>]

        # @!method count_by_filter(filter)
        #   @param [Mihari::Structs::Filters::Search] filter
        #   @return [Integer]
      end

      private

      #
      # @return [Array<Mihari::Enrichers::Base>]
      #
      def callable_enrichers
        @callable_enrichers ||= Mihari.enrichers.map(&:new).select do |enricher|
          enricher.callable?(self)
        end
      end

      def set_data_type
        self.data_type = DataType.type(data)
      end

      def set_rule_id
        @set_rule_id ||= nil
      end
    end
  end
end
