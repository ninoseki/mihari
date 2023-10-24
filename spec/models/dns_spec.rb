# frozen_string_literal: true

RSpec.describe Mihari::Models::DnsRecord, :vcr do
  describe ".build_by_domain" do
    let!(:domain) { "example.com" }

    it do
      dns_records = described_class.build_by_domain(domain)

      # example.com has A records and does not have CNAME records
      expect(dns_records.any? { |record| record.resource == "A" }).to be true
      expect(dns_records.any? { |record| record.resource == "CNAME" }).to be false
    end
  end
end
