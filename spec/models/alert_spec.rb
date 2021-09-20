# frozen_string_literal: true

RSpec.describe Mihari::Alert do
  include_context "with database fixtures"

  describe ".search" do
    it do
      alerts = described_class.search
      expect(alerts.length).to eq(2)
    end

    it do
      alerts = described_class.search(tag_name: "tag1")
      expect(alerts.length).to eq(1)
    end

    it do
      alerts = described_class.search(artifact_data: "1.1.1.1")
      expect(alerts.length).to eq(1)
    end

    it do
      alerts = described_class.search(source: "foo")
      expect(alerts.length).to eq(0)
    end

    it do
      alerts = described_class.search(asn: 13_335)
      expect(alerts.length).to eq(1)
    end

    it do
      alerts = described_class.search(reverse_dns_name: "one.one.one.one")
      expect(alerts.length).to eq(1)
    end

    it do
      alerts = described_class.search(dns_record: "93.184.216.34")
      expect(alerts.length).to eq(1)
    end
  end

  describe ".count" do
    it do
      count = described_class.count()
      expect(count).to eq(2)
    end

    it do
      count = described_class.count(tag_name: "tag1")
      expect(count).to eq(1)
    end

    it do
      count = described_class.count(artifact_data: "1.1.1.1")
      expect(count).to eq(1)
    end

    it do
      count = described_class.count(source: "foo")
      expect(count).to eq(0)
    end

    it do
      count = described_class.count(asn: 13_335)
      expect(count).to eq(1)
    end

    it do
      count = described_class.count(reverse_dns_name: "one.one.one.one")
      expect(count).to eq(1)
    end

    it do
      count = described_class.count(dns_record: "93.184.216.34")
      expect(count).to eq(1)
    end
  end
end
