# frozen_string_literal: true

RSpec.describe Mihari::Alert do
  include_context "with database fixtures"

  describe ".search" do
    it do
      alerts = described_class.search(Mihari::Structs::Filters::Alert::SearchFilterWithPagination.new)
      expect(alerts.length).to eq(2)
    end

    it do
      alerts = described_class.search(Mihari::Structs::Filters::Alert::SearchFilterWithPagination.new(tag_name: "tag1"))
      expect(alerts.length).to eq(1)
    end

    it do
      alerts = described_class.search(Mihari::Structs::Filters::Alert::SearchFilterWithPagination.new(artifact_data: "1.1.1.1"))
      expect(alerts.length).to eq(1)
    end

    it do
      alerts = described_class.search(Mihari::Structs::Filters::Alert::SearchFilterWithPagination.new(source: "foo"))
      expect(alerts.length).to eq(0)
    end

    it do
      alerts = described_class.search(Mihari::Structs::Filters::Alert::SearchFilterWithPagination.new(asn: 13_335))
      expect(alerts.length).to eq(1)
    end

    it do
      alerts = described_class.search(Mihari::Structs::Filters::Alert::SearchFilterWithPagination.new(reverse_dns_name: "one.one.one.one"))
      expect(alerts.length).to eq(1)
    end

    it do
      alerts = described_class.search(Mihari::Structs::Filters::Alert::SearchFilterWithPagination.new(dns_record: "93.184.216.34"))
      expect(alerts.length).to eq(1)
    end
  end

  describe ".count" do
    it do
      count = described_class.count(Mihari::Structs::Filters::Alert::SearchFilter.new)
      expect(count).to eq(2)
    end

    it do
      count = described_class.count(Mihari::Structs::Filters::Alert::SearchFilter.new(tag_name: "tag1"))
      expect(count).to eq(1)
    end

    it do
      count = described_class.count(Mihari::Structs::Filters::Alert::SearchFilter.new(artifact_data: "1.1.1.1"))
      expect(count).to eq(1)
    end

    it do
      count = described_class.count(Mihari::Structs::Filters::Alert::SearchFilter.new(source: "foo"))
      expect(count).to eq(0)
    end

    it do
      count = described_class.count(Mihari::Structs::Filters::Alert::SearchFilter.new(asn: 13_335))
      expect(count).to eq(1)
    end

    it do
      count = described_class.count(Mihari::Structs::Filters::Alert::SearchFilter.new(reverse_dns_name: "one.one.one.one"))
      expect(count).to eq(1)
    end

    it do
      count = described_class.count(Mihari::Structs::Filters::Alert::SearchFilter.new(dns_record: "93.184.216.34"))
      expect(count).to eq(1)
    end
  end
end
