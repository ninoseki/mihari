# frozen_string_literal: true

RSpec.describe Mihari::Enrichers::Whois do
  subject { described_class.new }

  describe ".query" do
    let!(:domain) { "example.com" }

    before { subject.reset_cache }

    it do
      whois_record = subject.query(domain)
      expect(whois_record.created_on&.iso8601).to eq("1992-01-01")
      expect(whois_record.registrar).to be_a(Hash).or be_a(NilClass)
      expect(whois_record.contacts).to be_a(Array)
    end
  end
end
