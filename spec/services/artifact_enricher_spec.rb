# frozen_string_literal: true

RSpec.describe Mihari::Services::ArtifactEnricher do
  describe ".call" do
    let!(:artifact) do
      FactoryBot.create(:artifact, :unenrichable)
    end

    it do
      expect(described_class.call(artifact.id)).to eq(true)
    end
  end
end
