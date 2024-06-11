# frozen_string_literal: true

RSpec.describe Mihari::Services::ArtifactEnricher, vcr: "Mihari_Services_ArtifactEnricher/ip:1.1.1.1" do
  describe ".call" do
    context "with enrichable artifact" do
      let(:artifact) do
        artifact = FactoryBot.build(:artifact, :ip).tap { |tapped| tapped.data = "1.1.1.1" }
        artifact.save
        artifact
      end

      it do
        expect(described_class.call(artifact.id)).to be(true)
      end
    end

    context "with unenrichable artifact" do
      let(:artifact) do
        FactoryBot.create(:artifact, :unenrichable)
      end

      it do
        expect { described_class.call(artifact.id) }.to raise_error(Mihari::UnenrichableError)
      end
    end
  end
end
