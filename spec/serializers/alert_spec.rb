# frozen_string_literal: true

RSpec.describe Mihari::AlertSerializer do
  let(:alert) {
    Mihari::Alert.new(
      title: "foo",
      source: "bar",
      artifacts: [
        Mihari::Artifact.new(data: "1.1.1.1")
      ]
    )
  }

  describe "#as_json" do
    it do
      json = described_class.new(alert).as_json
      expect(json).to eq(
        {
          title: "foo",
          source: "bar",
          created_at: nil,
          description: nil,
          artifacts: [{ data: "1.1.1.1", data_type: "ip" }],
          tags: []
        }
      )
    end
  end
end
