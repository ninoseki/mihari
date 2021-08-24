# frozen_string_literal: true

require "timecop"

RSpec.describe Mihari::Artifact do
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

    context "with --ignore-old-artifacts" do
      let(:days) { 2 }
      let(:data) { "1.1.1.1" }

      before do
        described_class.all.each(&:delete)

        Timecop.freeze((-days).days.from_now) do
          described_class.create(data: data)
        end
      end

      it do
        artifact = described_class.new(data: data)

        (0..days).each do |day|
          expect(artifact.unique?(ignore_old_artifacts: true, ignore_threshold: day)).to eq(true)
        end

        expect(artifact.unique?(ignore_old_artifacts: true, ignore_threshold: days + 1)).to eq(false)
        expect(artifact.unique?(ignore_old_artifacts: true, ignore_threshold: days + 2)).to eq(false)
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
end
