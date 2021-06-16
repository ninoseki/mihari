# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Rule, :vcr do
  let(:title) { "test" }
  let(:description) { "test" }
  let(:queries) {
    [
      { analyzer: "shodan", query: "ip:1.1.1.1" },
      { analyzer: "crtsh", query: "www.example.org", exclude_expired: true }
    ]
  }
  let(:tags) { %w[test] }

  subject { described_class.new(title: title, description: description, tags: tags, queries: queries) }

  describe "#title" do
    it do
      expect(subject.title).to eq(title)
    end
  end

  describe "#description" do
    it do
      expect(subject.description).to eq(description)
    end
  end

  describe "#artifacts" do
    it do
      artifacts = subject.artifacts
      expect(artifacts).to be_an(Array)
      expect(artifacts.length).to eq(2) # 1.1.1.1 and www.example.com
    end
  end

  describe "#tags" do
    it do
      expect(subject.tags).to eq(tags)
    end
  end

  context "with duplicated artifacts" do
    let(:queries) {
      [
        { analyzer: "shodan", query: "ip:1.1.1.1" },
        { analyzer: "censys", query: "ip:1.1.1.1" }
      ]
    }

    describe "#normalized_artifacts" do
      it do
        artifacts = subject.normalized_artifacts
        expect(artifacts).to be_an(Array)
        expect(artifacts.length).to eq(1) # 1.1.1.1
      end
    end
  end
end
