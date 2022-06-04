# frozen_string_literal: true

RSpec.describe Mihari::Enrichers::Whois, :vcr do
  subject { described_class }

  describe ".query" do
    let(:domain) { "example.com" }

    before { subject.reset_cache }

    it do
      res = subject.query(domain)
      expect(res.created_on&.iso8601).to eq("1992-01-01")
    end
  end
end
