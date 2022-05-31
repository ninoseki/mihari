# frozen_string_literal: true

RSpec.describe Mihari::DnsRecord, :vcr do
  describe ".build_by_domain" do
    let(:domain) { "example.com" }

    it do
      dns_records = described_class.build_by_domain(domain)

      # example.com has A records and does not have CNAME records
      expect(dns_records.any? { |record| record.resource == "A" }).to eq(true)
      expect(dns_records.any? { |record| record.resource == "CNAME" }).to eq(false)
    end
  end
end
