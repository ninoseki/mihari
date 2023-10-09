# frozen_string_literal: true

RSpec.describe Mihari::Alert do
  include_context "with database fixtures"

  let!(:alert) { Mihari::Alert.first }
  let!(:artifact_data) { Mihari::Artifact.where(alert_id: alert.id).first.data }
  let!(:tag_name) { alert.tags.first.name }
  let!(:asn) { Mihari::AutonomousSystem.first.asn }
  let!(:reverse_dns_name) { Mihari::ReverseDnsName.first.name }
  let!(:dns_record) { Mihari::DnsRecord.first.value }

  describe ".search" do
    it do
      alerts = described_class.search(
        Mihari::Structs::Filters::Alert::SearchFilterWithPagination.new
      )
      expect(alerts.length).to be >= 2
    end

    it do
      alerts = described_class.search(
        Mihari::Structs::Filters::Alert::SearchFilterWithPagination.new(
          tag_name: tag_name
        )
      )
      expect(alerts.length).to eq(1)
    end

    it do
      alerts = described_class.search(
        Mihari::Structs::Filters::Alert::SearchFilterWithPagination.new(
          artifact_data: artifact_data
        )
      )
      expect(alerts.length).to eq(1)
    end

    it do
      alerts = described_class.search(
        Mihari::Structs::Filters::Alert::SearchFilterWithPagination.new(
          rule_id: "404"
        )
      )
      expect(alerts.length).to eq(0)
    end
  end

  describe ".count" do
    it do
      count = described_class.count(
        Mihari::Structs::Filters::Alert::SearchFilter.new
      )
      expect(count).to be >= 2
    end

    it do
      count = described_class.count(
        Mihari::Structs::Filters::Alert::SearchFilter.new(
          tag_name: tag_name
        )
      )
      expect(count).to eq(1)
    end

    it do
      count = described_class.count(
        Mihari::Structs::Filters::Alert::SearchFilter.new(
          artifact_data: artifact_data
        )
      )
      expect(count).to eq(1)
    end

    it do
      count = described_class.count(
        Mihari::Structs::Filters::Alert::SearchFilter.new(
          rule_id: "404"
        )
      )
      expect(count).to eq(0)
    end
  end
end
