# frozen_string_literal: true

RSpec.describe Mihari::Serializers::ArtifactSerializer do
  let(:artifact) { Mihari::Artifact.new(data: "1.1.1.1") }

  describe "#as_json" do
    it do
      json = described_class.new(artifact).as_json
      expect(json[:data]).to eq("1.1.1.1")
      expect(json[:data_type]).to eq("ip")
    end
  end
end
