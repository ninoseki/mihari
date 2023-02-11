# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Rule, :vcr do
  let(:title) { "test" }
  let(:description) { "test" }
  let(:queries) do
    [
      { analyzer: "shodan", query: "ip:1.1.1.1" },
      { analyzer: "crtsh", query: "www.example.org", exclude_expired: true }
    ]
  end
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

  describe "#source" do
    it do
      expect(subject.source).to be_a(String)
    end
  end

  context "with duplicated artifacts" do
    let(:queries) do
      [
        { analyzer: "shodan", query: "ip:1.1.1.1" },
        { analyzer: "censys", query: "ip:1.1.1.1" }
      ]
    end

    describe "#normalized_artifacts" do
      it do
        artifacts = subject.normalized_artifacts
        expect(artifacts).to be_an(Array)
        expect(artifacts.length).to eq(1) # 1.1.1.1
      end
    end
  end

  context "with disallowed data values in string", vcr: "Mihari_Analyzers_Rule/shodan_ip:1.1.1.1" do
    subject do
      described_class.new(
        title: title,
        description: description,
        tags: tags,
        queries: queries,
        disallowed_data_values: ["8.8.8.8", "9.9.9.9", "1.1.1.1"]
      )
    end

    let(:queries) do
      [
        { analyzer: "shodan", query: "ip:1.1.1.1" }
      ]
    end

    describe "#normalized_artifacts" do
      it do
        artifacts = subject.normalized_artifacts
        expect(artifacts).to be_an(Array)
        expect(artifacts.length).to eq(0)
      end
    end
  end

  context "with disallowed data values in regexp", vcr: "Mihari_Analyzers_Rule/shodan_ip:1.1.1.1" do
    subject do
      described_class.new(
        title: title,
        description: description,
        tags: tags,
        queries: queries,
        disallowed_data_values: ["/[a-z]+/", "/^1.1.*$/"]
      )
    end

    let(:queries) do
      [
        { analyzer: "shodan", query: "ip:1.1.1.1" }
      ]
    end

    describe "#normalized_artifacts" do
      it do
        artifacts = subject.normalized_artifacts
        expect(artifacts).to be_an(Array)
        expect(artifacts.length).to eq(0)
      end
    end
  end

  context "with disallowed data types", vcr: "Mihari_Analyzers_Rule/shodan_ip:1.1.1.1" do
    subject do
      described_class.new(
        title: title,
        description: description,
        tags: tags,
        queries: queries,
        data_types: ["domain"]
      )
    end

    let(:queries) do
      [
        { analyzer: "shodan", query: "ip:1.1.1.1" }
      ]
    end

    describe "#normalized_artifacts" do
      it do
        artifacts = subject.normalized_artifacts
        expect(artifacts).to be_an(Array)
        expect(artifacts.length).to eq(0)
      end
    end
  end

  context "with id", vcr: "Mihari_Analyzers_Rule/shodan_ip:1.1.1.1" do
    subject do
      described_class.new(
        title: title,
        description: description,
        queries: queries,
        id: id
      )
    end

    let(:id) { "foo" }

    let(:queries) do
      [
        { analyzer: "shodan", query: "ip:1.1.1.1" }
      ]
    end

    describe "#source" do
      it do
        expect(subject.source).to eq(id)
      end
    end
  end

  context "with invalid analyzer in queries" do
    subject do
      described_class.new(
        title: title,
        description: description,
        queries: queries
      )
    end

    let(:queries) do
      [
        { analyzer: "shodan", query: "ip:1.1.1.1" }
      ]
    end

    before do
      allow(Mihari.config).to receive(:shodan_api_key).and_return(nil)
    end

    it do
      expect { subject.artifacts }.to raise_error(Mihari::ConfigurationError, "Shodan is not configured correctly")
    end
  end
end
