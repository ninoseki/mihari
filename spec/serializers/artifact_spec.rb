# frozen_string_literal: true

RSpec.describe Mihari::ArtifactSerializer do
  let(:artifact) { Mihari::Artifact.new(data: "1.1.1.1") }

  describe "#as_json" do
    it do
      json = described_class.new(artifact).as_json
      expect(json).to eq({data: "1.1.1.1", data_type: "ip"})
    end
  end
end
