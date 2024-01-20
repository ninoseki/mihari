# frozen_string_literal: true

RSpec.describe Mihari::Enrichers::MMDB, :vcr do
  subject(:enricher) { described_class.new }

  describe ".call" do
    let!(:artifact) { Mihari::Models::Artifact.new(data: "1.1.1.1") }

    it do
      enricher.call artifact
      expect(artifact.autonomous_system.number).to eq(13_335)
      expect(artifact.geolocation.country_code).to eq("US")
    end
  end
end
