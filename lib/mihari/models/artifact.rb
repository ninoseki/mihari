# frozen_string_literal: true

class ArtifactValidator < ActiveModel::Validator
  def validate(record)
    return if record.data_type

    record.errors.add :data, "#{record.data} is not supported"
  end
end

module Mihari
  class Artifact < ActiveRecord::Base
    belongs_to :alert

    has_one :autonomous_system, dependent: :destroy
    has_one :geolocation, dependent: :destroy
    has_one :whois_record, dependent: :destroy

    has_many :cpes, dependent: :destroy
    has_many :dns_records, dependent: :destroy
    has_many :ports, dependent: :destroy
    has_many :reverse_dns_names, dependent: :destroy

    include ActiveModel::Validations

    validates_with ArtifactValidator

    attr_accessor :tags

    def initialize(*args, **kwargs)
      attrs = args.first || kwargs
      data_ = attrs[:data]

      raise InvalidArtifactFormatError if data_.is_a?(Array) || data_.is_a?(Hash)

      super(*args, **kwargs)

      self.data_type = TypeChecker.type(data)
      self.tags = []
    end

    #
    # Check uniqueness of artifact
    #
    # @param [Time] base_time Base time to check decaying
    # @param [Integer, nil] artifact_lifetime Artifact lifetime (TTL) in seconds
    #
    # @return [Boolean] true if it is unique. Otherwise false.
    #
    def unique?(base_time:, artifact_lifetime: nil)
      artifact = self.class.where(data: data).order(created_at: :desc).first
      return true if artifact.nil?

      # check whetehr the artifact is decayed or not
      return true if artifact_lifetime.nil?

      decayed_at = base_time - (artifact_lifetime || -1).seconds
      artifact.created_at < decayed_at
    end

    #
    # Enrich(add) whois record
    #
    def enrich_whois
      return unless can_enrich_whois?

      self.whois_record = WhoisRecord.build_by_domain(normalize_as_domain(data))
    end

    #
    # Enrich(add) DNS records
    #
    def enrich_dns
      return unless can_enrich_dns?

      self.dns_records = DnsRecord.build_by_domain(normalize_as_domain(data))
    end

    #
    # Enrich(add) reverse DNS names
    #
    def enrich_reverse_dns
      return unless can_enrich_revese_dns?

      self.reverse_dns_names = ReverseDnsName.build_by_ip(data)
    end

    #
    # Enrich(add) geolocation
    #
    def enrich_geolocation
      return unless can_enrich_geolocation?

      self.geolocation = Geolocation.build_by_ip(data)
    end

    #
    # Enrich AS
    #
    def enrich_autonomous_system
      return unless can_enrich_autonomous_system?

      self.autonomous_system = AutonomousSystem.build_by_ip(data)
    end

    #
    # Enrich ports
    #
    def enrich_ports
      return unless can_enrich_ports?

      self.ports = Port.build_by_ip(data)
    end

    #
    # Enrich CPEs
    #
    def enrich_cpes
      return unless can_enrich_cpes?

      self.cpes = CPE.build_by_ip(data)
    end

    #
    # Enrich all the enrichable relationships of the artifact
    #
    def enrich_all
      enrich_autonomous_system
      enrich_dns
      enrich_geolocation
      enrich_reverse_dns
      enrich_whois
      enrich_ports
      enrich_cpes
    end

    ENRICH_METHODS_BY_ENRICHER = {
      whois: [
        :enrich_whois
      ],
      ipinfo: %i[
        enrich_autonomous_system
        enrich_geolocation
      ],
      shodan: %i[
        enrich_ports
        enrich_cpes
        enrich_reverse_dns
      ],
      google_public_dns: [
        :enrich_dns
      ]
    }.freeze

    #
    # Enrich by name of enricher
    #
    # @param [String] enricher
    #
    def enrich_by_enricher(enricher)
      methods = ENRICH_METHODS_BY_ENRICHER[enricher.downcase.to_sym] || []
      methods.each do |method|
        send(method) if respond_to?(method)
      end
    end

    private

    def normalize_as_domain(url_or_domain)
      return url_or_domain if data_type == "domain"

      Addressable::URI.parse(url_or_domain).host
    end

    def can_enrich_whois?
      %w[domain url].include?(data_type) && whois_record.nil?
    end

    def can_enrich_dns?
      %w[domain url].include?(data_type) && dns_records.empty?
    end

    def can_enrich_revese_dns?
      data_type == "ip" && reverse_dns_names.empty?
    end

    def can_enrich_geolocation?
      data_type == "ip" && geolocation.nil?
    end

    def can_enrich_autonomous_system?
      data_type == "ip" && autonomous_system.nil?
    end

    def can_enrich_ports?
      data_type == "ip" && ports.empty?
    end

    def can_enrich_cpes?
      data_type == "ip" && cpes.empty?
    end
  end
end
