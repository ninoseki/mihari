# frozen_string_literal: true

RSpec.describe Mihari::Models::Alert do
  include_context "with database fixtures"

  let_it_be(:alert) { described_class.first }
  let_it_be(:artifact_data) { Mihari::Models::Artifact.where(alert_id: alert.id).first.data }
  let_it_be(:tag_name) { alert.tags.first.name }
  let_it_be(:asn) { Mihari::Models::AutonomousSystem.first.asn }
  let_it_be(:reverse_dns_name) { Mihari::Models::ReverseDnsName.first.name }
  let_it_be(:dns_record) { Mihari::Models::DnsRecord.first.value }

  let(:tag_filter) do
    Mihari::Structs::Filters::Alert::SearchFilterWithPagination.new(
      tag_name: tag_name
    )
  end
  let(:artifact_filter) do
    Mihari::Structs::Filters::Alert::SearchFilterWithPagination.new(
      artifact_data: artifact_data
    )
  end
  let(:empty_rule_filter) do
    Mihari::Structs::Filters::Alert::SearchFilterWithPagination.new(
      rule_id: "404"
    )
  end

  describe ".search" do
    it do
      alerts = described_class.search(Mihari::Structs::Filters::Alert::SearchFilterWithPagination.new)
      expect(alerts.length).to be >= 2
    end

    where(:filter, :expected) do
      [
        [ref(:tag_filter), 1],
        [ref(:artifact_filter), 1],
        [ref(:empty_rule_filter), 0]
      ]
    end

    with_them do
      it do
        alerts = described_class.search(filter)
        expect(alerts.length).to eq(expected)
      end
    end
  end

  describe ".count" do
    it do
      count = described_class.count(
        Mihari::Structs::Filters::Alert::SearchFilter.new
      )
      expect(count).to be >= 2
    end

    where(:filter, :expected) do
      [
        [ref(:tag_filter), 1],
        [ref(:artifact_filter), 1],
        [ref(:empty_rule_filter), 0]
      ]
    end

    with_them do
      it do
        count = described_class.count(filter)
        expect(count).to eq(expected)
      end
    end
  end
end
