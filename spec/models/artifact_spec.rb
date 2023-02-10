# frozen_string_literal: true

require "timecop"

RSpec.describe Mihari::Artifact, :vcr do
  describe "#validate" do
    it do
      artifact = described_class.new(data: "1.1.1.1")
      expect(artifact).to be_valid
      expect(artifact.data_type).to eq("ip")
    end
  end

  describe "#unique?" do
    before do
      described_class.all.each(&:delete)
      described_class.create(data: "1.1.1.1")
    end

    it do
      artifact = described_class.new(data: "1.1.1.1")
      expect(artifact).not_to be_unique
    end

    it do
      artifact = described_class.new(data: "2.2.2.2")
      expect(artifact).to be_unique
    end

    context "with artifact_lifetime" do
      let(:data) { "1.1.1.1" }
      let(:artifact_lifetime) { 60 }
      let(:base_time) { Time.now.utc }

      before do
        described_class.all.each(&:delete)
      end

      it do
        Timecop.freeze(base_time) do
          described_class.create(data: data)
        end

        artifact = described_class.new(data: data)
        expect(artifact.unique?(base_time: base_time, artifact_lifetime: artifact_lifetime)).to eq(false)
      end

      it do
        Timecop.freeze(base_time - (artifact_lifetime + 1).seconds) do
          described_class.create(data: data)
        end

        artifact = described_class.new(data: data)
        expect(artifact.unique?(base_time: base_time, artifact_lifetime: artifact_lifetime)).to eq(true)
      end
    end
  end

  describe "#enrich_whois" do
    let(:data) { "example.com" }

    it do
      artifact = described_class.new(data: data)
      expect(artifact.whois_record).to be_nil

      artifact.enrich_whois
      expect(artifact.whois_record).not_to be_nil
    end

    context "with URL" do
      let(:data) { "https://example.com" }

      it do
        artifact = described_class.new(data: data)
        expect(artifact.whois_record).to be_nil

        artifact.enrich_whois
        expect(artifact.whois_record).not_to be_nil
      end
    end
  end

  describe "#enrich_dns" do
    let(:data) { "example.com" }

    it do
      artifact = described_class.new(data: data)
      expect(artifact.dns_records.length).to eq(0)

      artifact.enrich_dns
      expect(artifact.dns_records.length).to be > 0
    end

    context "with URL" do
      let(:data) { "https://example.com" }

      it do
        artifact = described_class.new(data: data)
        expect(artifact.dns_records.length).to eq(0)

        artifact.enrich_dns
        expect(artifact.dns_records.length).to be > 0
      end
    end
  end

  describe "#enrich_dns", vcr: "Mihari_Enrichers_IPInfo/ip:1.1.1.1" do
    let(:data) { "1.1.1.1" }

    it do
      artifact = described_class.new(data: data)
      expect(artifact.geolocation).to eq(nil)

      artifact.enrich_geolocation
      expect(artifact.geolocation.country_code).to eq("US")
    end
  end

  describe "#enrich_autonomos_system", vcr: "Mihari_Enrichers_IPInfo/ip:1.1.1.1" do
    let(:data) { "1.1.1.1" }

    it do
      artifact = described_class.new(data: data)
      expect(artifact.autonomous_system).to eq(nil)

      artifact.enrich_autonomous_system
      expect(artifact.autonomous_system.asn).to eq(13_335)
    end
  end

  describe "#enrich_by_enricher" do
    context "with IPInfo", vcr: "Mihari_Enrichers_IPInfo/ip:1.1.1.1" do
      let(:data) { "1.1.1.1" }

      it do
        artifact = described_class.new(data: data)
        expect(artifact.autonomous_system).to eq(nil)
        expect(artifact.geolocation).to eq(nil)

        artifact.enrich_by_enricher("ipinfo")
        expect(artifact.autonomous_system).not_to eq(nil)
        expect(artifact.geolocation).not_to eq(nil)
      end
    end

    context "with Shodan", vcr: "Mihari_Enrichers_Shodan/ip:1.1.1.1" do
      let(:data) { "1.1.1.1" }

      it do
        artifact = described_class.new(data: data)
        expect(artifact.reverse_dns_names.empty?).to be true
        expect(artifact.ports.empty?).to be true

        artifact.enrich_by_enricher("shodan")
        expect(artifact.reverse_dns_names.empty?).to be false
        expect(artifact.ports.empty?).to be false
      end
    end

    context "with Google Public DNS", :vcr do
      let(:data) { "example.com" }

      it do
        artifact = described_class.new(data: data)
        expect(artifact.dns_records.empty?).to be true

        artifact.enrich_by_enricher("google_public_dns")
        expect(artifact.dns_records.empty?).to be false
      end
    end

    context "with Whois" do
      let(:data) { "example.com" }

      it do
        artifact = described_class.new(data: data)
        expect(artifact.whois_record).to be_nil

        artifact.enrich_by_enricher("whois")
        expect(artifact.whois_record).not_to be_nil
      end
    end
  end
end
