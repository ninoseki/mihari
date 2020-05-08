# frozen_string_literal: true

RSpec.describe Mihari::Artifact do
  describe "#validate" do
    it do
      artifact = described_class.new(data: "1.1.1.1")
      expect(artifact).to be_valid
      expect(artifact.data_type).to eq("ip")
    end
  end

  describe "#unique?" do
    before do
      described_class.delete_all
      described_class.create(data: "1.1.1.1")
    end

    it do
      artifact = described_class.new(data: "1.1.1.1")
      expect(artifact).not_to be_unique
    end

    it do
      artifact = described_class.new(data: "2.2.2.2")
      expect(artifact).to be_unique
    end
  end
end
