# frozen_string_literal: true

RSpec.describe Mihari do
  it "has a version number" do
    expect(Mihari::VERSION).not_to be nil
  end

  it "has a config" do
    expect(described_class.config).not_to be nil
  end

  describe "#sidekiq?" do
    it "returns false in RSpec" do
      expect(described_class.sidekiq?).to eq(false)
    end
  end

  describe "#puma?" do
    it "returns false in RSpec" do
      expect(described_class.puma?).to eq(false)
    end
  end
end
