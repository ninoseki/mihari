# frozen_string_literal: true

RSpec.describe Mihari::Models::Artifact, :vcr do
  let_it_be(:artifact) { FactoryBot.create(:artifact) }
  let_it_be(:tag) { artifact.tags.first }
  let_it_be(:alert) { artifact.alert }
  let_it_be(:rule) { artifact.rule }

  let(:tag_filter) do
    Mihari::Structs::Filters::Search.new(q: "tag:#{tag.name}")
  end
  let(:empty_rule_filter) do
    Mihari::Structs::Filters::Search.new(q: "rule.id:404_not_found")
  end

  describe "#validate" do
    it do
      obj = described_class.new(data: Faker::Internet.ip_v4_address, alert_id: alert.id)
      expect(obj).to be_valid
      expect(obj.data_type).to eq("ip")
    end
  end

  describe "#unique?" do
    it do
      obj = described_class.new(data: artifact.data, alert_id: alert.id)
      obj.rule_id = rule.id
      expect(obj).not_to be_unique
    end

    it do
      obj = described_class.new(data: Faker::Internet.unique.ip_v4_address, alert_id: alert.id)
      expect(obj).to be_unique
    end

    context "with artifact_lifetime" do
      let(:data) { Faker::Internet.unique.ip_v4_address }
      let!(:artifact_ttl) { 60 }
      let!(:base_time) { Time.now.utc }

      it do
        Timecop.freeze(base_time) do
          described_class.create(data: artifact.data, alert_id: alert.id)
        end

        obj = described_class.new(data: artifact.data, alert_id: alert.id)
        obj.rule_id = rule.id

        expect(obj.unique?(base_time: base_time, artifact_ttl: artifact_ttl)).to be false
      end

      it do
        Timecop.freeze(base_time - (artifact_ttl + 1).seconds) do
          described_class.create(data: artifact.data, alert_id: alert.id)
        end

        obj = described_class.new(data: artifact.data, alert_id: alert.id)
        expect(obj.unique?(base_time: base_time, artifact_ttl: artifact_ttl)).to be true
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
      let(:artifact) { described_class.new(data: data, alert_id: alert.id) }

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
      let(:artifact) { described_class.new(data: data, alert_id: alert.id) }

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
      let(:artifact) { described_class.new(data: data, alert_id: alert.id) }

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
      let(:artifact) { described_class.new(data: data, alert_id: alert.id) }

      it do
        artifact = described_class.new(data: data, alert_id: alert.id)
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
    let(:artifact) { described_class.new(data: data, alert_id: alert.id) }

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
    let(:artifact) { described_class.new(data: data, alert_id: alert.id) }

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
      let(:artifact) { described_class.new(data: data, alert_id: alert.id) }

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
      let(:artifact) { described_class.new(data: data, alert_id: alert.id) }

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
      let(:artifact) { described_class.new(data: data, alert_id: alert.id) }

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
      let(:artifact) { described_class.new(data: data, alert_id: alert.id) }
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

  describe ".search_by_filter" do
    it do
      artifacts = described_class.search_by_filter(Mihari::Structs::Filters::Search.new(q: ""))
      expect(artifacts.length).to be >= alert.artifacts.length
    end

    it do
      artifacts = described_class.search_by_filter(tag_filter)
      expect(artifacts.length).to be >= alert.artifacts.length
    end

    it do
      artifacts = described_class.search_by_filter(empty_rule_filter)
      expect(artifacts.length).to eq(0)
    end
  end

  describe ".count_by_filter" do
    it do
      count = described_class.count_by_filter(Mihari::Structs::Filters::Search.new(q: ""))
      expect(count).to be >= alert.artifacts.length
    end

    it do
      count = described_class.count_by_filter(tag_filter)
      expect(count).to be >= alert.artifacts.length
    end

    it do
      count = described_class.count_by_filter(empty_rule_filter)
      expect(count).to eq(0)
    end
  end
end
