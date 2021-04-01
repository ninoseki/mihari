# frozen_string_literal: true

RSpec.describe Mihari::Alert do
  before do
    artifacts = [
      Mihari::Artifact.new(data: "1.1.1.1"),
      Mihari::Artifact.new(data: "example.com")
    ]

    database = Mihari::Emitters::Database.new
    database.emit(title: "test", description: "test", artifacts: artifacts, source: "json", tags: %w[tag1])
    database.emit(title: "test2", description: "tes2t", artifacts: artifacts, source: "json", tags: %w[tag2])
  end

  describe ".search" do
    it do
      alerts = described_class.search
      expect(alerts.length).to eq(2)
    end

    it do
      alerts = described_class.search(tag_name: "tag1")
      expect(alerts.length).to eq(1)
    end

    it do
      alerts = described_class.search(artifact_data: "1.1.1.1")
      expect(alerts.length).to eq(1)
    end

    it do
      alerts = described_class.search(source: "foo")
      expect(alerts.length).to eq(0)
    end
  end

  describe ".count" do
    it do
      count = described_class.count()
      expect(count).to eq(2)
    end

    it do
      count = described_class.count(tag_name: "tag1")
      expect(count).to eq(1)
    end

    it do
      count = described_class.count(artifact_data: "1.1.1.1")
      expect(count).to eq(1)
    end

    it do
      count = described_class.count(source: "foo")
      expect(count).to eq(0)
    end
  end
end
