# frozen_string_literal: true

RSpec.describe Mihari::Enrichers::GooglePublicDNS, :vcr do
  describe ".query_by_type" do
    subject(:enricher) { described_class.new }

    let!(:artifact) { Mihari::Models::Artifact.new(data: "example.com") }

    it do
      enricher.call artifact
      expect(artifact.dns_records.first.value).to eq("93.184.216.34")
    end
  end
end
