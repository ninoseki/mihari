# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Rule, :vcr do
  let(:id) { "test" }
  let(:title) { "test" }
  let(:description) { "test" }
  let(:queries) do
    [
      { analyzer: "crtsh", query: "www.example.com", exclude_expired: true }
    ]
  end
  let(:tags) { %w[test] }
  let(:falsepositives) { [] }
  let(:data_types) { Mihari::DEFAULT_DATA_TYPES }
  let(:rule) do
    Mihari::Structs::Rule.new(
      title: title,
      description: description,
      tags: tags,
      queries: queries,
      id: id,
      data_types: data_types,
      falsepositives: falsepositives
    )
  end

  subject { described_class.new(rule: rule) }

  describe "#artifacts", vcr: "Mihari_Analyzers_Rule/crt_sh:www.example.com" do
    it do
      artifacts = subject.artifacts
      expect(artifacts).to be_an(Array)
      expect(artifacts.length).to eq(1) # = www.example.com
    end
  end

  context "with duplicated artifacts" do
    let(:queries) do
      [
        { analyzer: "crtsh", query: "www.example.com", exclude_expired: true },
        { analyzer: "crtsh", query: "www.example.com", exclude_expired: true }
      ]
    end

    describe "#normalized_artifacts" do
      it do
        artifacts = subject.normalized_artifacts
        expect(artifacts).to be_an(Array)
        expect(artifacts.length).to eq(1) # www.example.com
      end
    end
  end

  context "with disallowed data values in string", vcr: "Mihari_Analyzers_Rule/crt_sh:www.example.com" do
    let(:falsepositives) { ["www.example.com"] }

    describe "#normalized_artifacts" do
      it do
        artifacts = subject.normalized_artifacts
        expect(artifacts).to be_an(Array)
        expect(artifacts.length).to eq(0)
      end
    end
  end

  context "with disallowed data values in regexp", vcr: "Mihari_Analyzers_Rule/crt_sh:www.example.com" do
    let(:falsepositives) { ["/[a-z.]+/"] }

    describe "#normalized_artifacts" do
      it do
        artifacts = subject.normalized_artifacts
        expect(artifacts).to be_an(Array)
        expect(artifacts.length).to eq(0)
      end
    end
  end

  context "with disallowed data types", vcr: "Mihari_Analyzers_Rule/crt_sh:www.example.com" do
    let(:data_types) { ["ip"] }

    describe "#normalized_artifacts" do
      it do
        artifacts = subject.normalized_artifacts
        expect(artifacts).to be_an(Array)
        expect(artifacts.length).to eq(0)
      end
    end
  end

  context "with invalid analyzer in queries" do
    let(:queries) do
      [
        { analyzer: "shodan", query: "ip:1.1.1.1" }
      ]
    end

    let(:rule) do
      Mihari::Structs::Rule.new(
        id: id,
        title: title,
        description: description,
        tags: tags,
        queries: queries
      )
    end

    before do
      allow(Mihari.config).to receive(:shodan_api_key).and_return(nil)
    end

    it do
      expect { subject.artifacts }.to raise_error(Mihari::ConfigurationError, "Shodan is not configured correctly")
    end
  end
end
