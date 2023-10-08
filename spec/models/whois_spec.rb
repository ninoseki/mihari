# frozen_string_literal: true

RSpec.describe Mihari::WhoisRecord do
  describe ".build_by_domain" do
    let!(:domain) { "example.com" }

    it do
      whois_record = described_class.build_by_domain(domain)

      expect(whois_record.domain).to eq(domain)
      expect(whois_record.created_on).to be_a(Date).or be_a(NilClass)
      expect(whois_record.registrar).to be_a(Hash).or be_a(NilClass)
      expect(whois_record.contacts).to be_a(Array)
    end
  end
end
