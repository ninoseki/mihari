# frozen_string_literal: true

RSpec.describe Mihari::Models::Artifact, :vcr do
  include_context "with database fixtures"

  let_it_be(:alert) { Mihari::Models::Alert.first }
  let_it_be(:tag) { alert.tags.first.name }
  let_it_be(:alert_id) { alert.id }
  let_it_be(:rule_id) { alert.rule_id }
  let_it_be(:data) { described_class.where(alert_id: alert_id).first.data }

  let(:tag_filter) do
    Mihari::Structs::Filters::Artifact::SearchFilterWithPagination.new(tag: tag)
  end
  let(:empty_rule_filter) do
    Mihari::Structs::Filters::Artifact::SearchFilterWithPagination.new(rule_id: "404")
  end

  describe "#validate" do
    it do
      artifact = described_class.new(data: "9.9.9.9", alert_id: alert_id)
      expect(artifact).to be_valid
      expect(artifact.data_type).to eq("ip")
    end
  end

  describe "#unique?" do
    it do
      artifact = described_class.new(data: data, alert_id: alert_id)
      artifact.rule_id = rule_id
      expect(artifact).not_to be_unique
    end

    it do
      artifact = described_class.new(data: Faker::Internet.unique.ip_v4_address, alert_id: alert_id)
      expect(artifact).to be_unique
    end

    context "with artifact_lifetime" do
      let(:data) { Faker::Internet.unique.ip_v4_address }
      let!(:artifact_lifetime) { 60 }
      let!(:base_time) { Time.now.utc }

      it do
        Timecop.freeze(base_time) do
          described_class.create(data: data, alert_id: alert_id)
        end

        artifact = described_class.new(data: data, alert_id: alert_id)
        artifact.rule_id = rule_id

        expect(artifact.unique?(base_time: base_time, artifact_lifetime: artifact_lifetime)).to be false
      end

      it do
        Timecop.freeze(base_time - (artifact_lifetime + 1).seconds) do
          described_class.create(data: data, alert_id: alert_id)
        end

        artifact = described_class.new(data: data, alert_id: alert_id)
        expect(artifact.unique?(base_time: base_time, artifact_lifetime: artifact_lifetime)).to be true
      end
    end
  end

  describe "#enrich_whois" do
    let!(:enricher) do
      enricher = instance_double("whois_enricher")
      allow(enricher).to receive(:result).and_return(
        Dry::Monads::Result::Success.new(
          Mihari::Models::WhoisRecord.new(domain: "example.com")
        )
      )
      enricher
    end

    context "with domain" do
      let(:data) { "example.com" }
      let(:artifact) { described_class.new(data: data, alert_id: alert_id) }

      it do
        expect(artifact.whois_record).to be_nil
      end

      it do
        artifact.enrich_whois enricher
        expect(artifact.whois_record).not_to be_nil
      end
    end

    context "with URL" do
      let(:data) { "https://example.com" }
      let(:artifact) { described_class.new(data: data, alert_id: alert_id) }

      it do
        expect(artifact.whois_record).to be_nil
      end

      it do
        artifact.enrich_whois enricher
        expect(artifact.whois_record).not_to be_nil
      end
    end
  end

  describe "#enrich_dns" do
    context "with domain" do
      let(:data) { "example.com" }
      let(:artifact) { described_class.new(data: data, alert_id: alert_id) }

      it do
        expect(artifact.dns_records.length).to eq(0)
      end

      it do
        artifact.enrich_dns
        expect(artifact.dns_records.length).to be > 0
      end
    end

    context "with URL" do
      let(:data) { "https://example.com" }
      let(:artifact) { described_class.new(data: data, alert_id: alert_id) }

      it do
        artifact = described_class.new(data: data, alert_id: alert_id)
        expect(artifact.dns_records.length).to eq(0)
      end

      it do
        artifact.enrich_dns
        expect(artifact.dns_records.length).to be > 0
      end
    end
  end

  describe "#enrich_geolocation" do
    let(:data) { "1.1.1.1" }
    let(:artifact) { described_class.new(data: data, alert_id: alert_id) }

    it do
      expect(artifact.geolocation).to eq(nil)
    end

    it do
      artifact.enrich_geolocation
      expect(artifact.geolocation.country_code).to eq("US")
    end
  end

  describe "#enrich_autonomous_system" do
    let(:data) { "1.1.1.1" }
    let(:artifact) { described_class.new(data: data, alert_id: alert_id) }

    it do
      expect(artifact.autonomous_system).to eq(nil)
    end

    it do
      artifact.enrich_autonomous_system
      expect(artifact.autonomous_system.asn).to eq(13_335)
    end
  end

  describe "#enrich_by_enricher" do
    context "with IPInfo" do
      let(:data) { "1.1.1.1" }
      let(:artifact) { described_class.new(data: data, alert_id: alert_id) }

      it do
        expect(artifact.autonomous_system).to eq(nil)
        expect(artifact.geolocation).to eq(nil)
      end

      it do
        artifact.enrich_by_enricher Mihari::Enrichers::IPInfo.new
        expect(artifact.autonomous_system).not_to eq(nil)
        expect(artifact.geolocation).not_to eq(nil)
      end
    end

    context "with Shodan" do
      let(:data) { "1.1.1.1" }
      let(:artifact) { described_class.new(data: data, alert_id: alert_id) }

      it do
        expect(artifact.reverse_dns_names.empty?).to be true
        expect(artifact.ports.empty?).to be true
      end

      it do
        artifact.enrich_by_enricher Mihari::Enrichers::Shodan.new
        expect(artifact.reverse_dns_names.empty?).to be false
        expect(artifact.ports.empty?).to be false
      end
    end

    context "with Google Public DNS" do
      let(:data) { "example.com" }
      let(:artifact) { described_class.new(data: data, alert_id: alert_id) }

      it do
        expect(artifact.dns_records.empty?).to be true
      end

      it do
        artifact.enrich_by_enricher(Mihari::Enrichers::GooglePublicDNS.new)
        expect(artifact.dns_records.empty?).to be false
      end
    end

    context "with Whois" do
      let(:data) { "example.com" }
      let(:artifact) { described_class.new(data: data, alert_id: alert_id) }
      let!(:enricher) do
        enricher = instance_double("whois_enricher")
        allow(enricher).to receive(:result).and_return(
          Dry::Monads::Result::Success.new(
            Mihari::Models::WhoisRecord.new(domain: data)
          )
        )
        allow(enricher).to receive(:class).and_return(Mihari::Enrichers::Whois)
        enricher
      end

      it do
        expect(artifact.whois_record).to be_nil
      end

      it do
        artifact.enrich_by_enricher(enricher)
        expect(artifact.whois_record).not_to be_nil
      end
    end
  end

  describe ".search" do
    it do
      artifacts = described_class.search(Mihari::Structs::Filters::Artifact::SearchFilterWithPagination.new)
      expect(artifacts.length).to be >= alert.artifacts.length
    end

    it do
      artifacts = described_class.search(tag_filter)
      expect(artifacts.length).to be >= alert.artifacts.length
    end

    it do
      artifacts = described_class.search(empty_rule_filter)
      expect(artifacts.length).to eq(0)
    end
  end

  describe ".count" do
    it do
      count = described_class.count(Mihari::Structs::Filters::Artifact::SearchFilter.new)
      expect(count).to be >= alert.artifacts.length
    end

    it do
      count = described_class.count(tag_filter)
      expect(count).to be >= alert.artifacts.length
    end

    it do
      count = described_class.count(empty_rule_filter)
      expect(count).to eq(0)
    end
  end
end
