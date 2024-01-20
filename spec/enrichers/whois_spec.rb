# frozen_string_literal: true

RSpec.describe Mihari::Enrichers::Whois do
  subject(:enricher) { described_class.new }

  describe "#call" do
    let!(:artifact) { Mihari::Models::Artifact.new(data: "example.com") }

    it do
      enricher.call artifact
      expect(artifact.whois_record.created_on&.iso8601).to eq("1992-01-01")
      expect(artifact.whois_record.registrar).to be_a(Hash).or be_a(NilClass)
      expect(artifact.whois_record.contacts).to be_a(Array)
    end
  end
end
