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

  describe "#source" do
    it do
      # UUIDTools::UUID.md5_create(UUIDTools::UUID_URL_NAMESPACE, title + description).to_s
      expect(subject.source).to eq("ce0da7c8-a87e-3782-8dc4-22dd52d9068a")
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

  context "with disallowed data values in string", vcr: "Mihari_Analyzers_Rule/shodan_ip:1.1.1.1" do
    subject do
      described_class.new(
        title: title,
        description: description,
        tags: tags,
        queries: queries,
        disallowed_data_values: ["1.1.1.1"]
      )
    end

    let(:queries) {
      [
        { analyzer: "shodan", query: "ip:1.1.1.1" }
      ]
    }

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
        disallowed_data_values: ["/1.1.*/"]
      )
    end

    let(:queries) {
      [
        { analyzer: "shodan", query: "ip:1.1.1.1" }
      ]
    }

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
        allowed_data_types: ["domain"]
      )
    end

    let(:queries) {
      [
        { analyzer: "shodan", query: "ip:1.1.1.1" }
      ]
    }

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

    let(:queries) {
      [
        { analyzer: "shodan", query: "ip:1.1.1.1" }
      ]
    }

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

    let(:queries) {
      [
        { analyzer: "shodan", query: "ip:1.1.1.1" }
      ]
    }

    before do
      allow(Mihari.config).to receive(:shodan_api_key).and_return(nil)
    end

    it do
      expect { subject.artifacts }.to raise_error(ArgumentError, "Shodan is not configured correctly")
    end
  end
end
