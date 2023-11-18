# frozen_string_literal: true

RSpec.describe Mihari::Enrichers::Whois do
  subject(:enricher) { described_class.new }

  describe ".call" do
    let!(:domain) { "example.com" }

    it do
      whois_record = enricher.call(domain)
      expect(whois_record.created_on&.iso8601).to eq("1992-01-01")
      expect(whois_record.registrar).to be_a(Hash).or be_a(NilClass)
      expect(whois_record.contacts).to be_a(Array)
    end
  end
end
