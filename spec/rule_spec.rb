# frozen_string_literal: true

RSpec.describe Mihari::Rule, :vcr do
  include_context "with mocked logger"

  let!(:id) { "test" }
  let!(:title) { "test" }
  let!(:description) { "test" }
  let(:queries) do
    [
      { analyzer: "crtsh", query: "www.example.com", exclude_expired: true }
    ]
  end
  let!(:tags) { %w[test] }
  let(:falsepositives) { [] }
  let(:data_types) { Mihari::DEFAULT_DATA_TYPES }
  let!(:emitters) { [{ emitter: "database" }] }
  let(:rule) do
    Mihari::Rule.new(
      title: title,
      description: description,
      tags: tags,
      queries: queries,
      id: id,
      data_types: data_types,
      falsepositives: falsepositives,
      emitters: emitters
    )
  end

  describe "#artifacts", vcr: "Mihari_Rule/crt_sh:www.example.com" do
    it do
      artifacts = rule.artifacts
      expect(artifacts).to be_an(Array)
      expect(artifacts.length).to eq(1) # = www.example.com
    end
  end

  describe "#model" do
    it "returns a model" do
      expect(rule.model).to be_a Mihari::Models::Rule
    end
  end

  describe "#errors?" do
    it "doesn't have any errors" do
      expect(rule.errors?).to be false
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
        artifacts = rule.normalized_artifacts
        expect(artifacts).to be_an(Array)
        expect(artifacts.length).to eq(1) # www.example.com
      end
    end
  end

  context "with string false positive", vcr: "Mihari_Rule/crt_sh:www.example.com" do
    let(:falsepositives) { ["www.example.com"] }

    describe "#normalized_artifacts" do
      it do
        artifacts = rule.normalized_artifacts
        expect(artifacts).to be_an(Array)
        expect(artifacts.length).to eq(0)
      end
    end
  end

  context "with regexp false positive", vcr: "Mihari_Rule/crt_sh:www.example.com" do
    let(:falsepositives) { ["/[a-z.]+/"] }

    describe "#normalized_artifacts" do
      it do
        artifacts = rule.normalized_artifacts
        expect(artifacts).to be_an(Array)
        expect(artifacts.length).to eq(0)
      end
    end
  end

  context "with data types", vcr: "Mihari_Rule/crt_sh:www.example.com" do
    let(:data_types) { ["ip"] }

    describe "#normalized_artifacts" do
      it do
        artifacts = rule.normalized_artifacts
        expect(artifacts).to be_an(Array)
        expect(artifacts.length).to eq(0)
      end
    end
  end

  context "with an invalid analyzer" do
    let(:queries) do
      [
        { analyzer: "shodan", query: "ip:1.1.1.1" }
      ]
    end

    let(:rule) do
      Mihari::Rule.new(
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
      expect { rule.artifacts }.to raise_error(Mihari::ConfigurationError, /Shodan is not configured correctly/)
    end
  end

  describe "#run" do
    before do
      allow(rule).to receive(:valid_emitters).and_return([])
      allow(rule).to receive(:enriched_artifacts).and_return([
        Mihari::Models::Artifact.new(data: "1.1.1.1")
      ])

      allow(Parallel).to receive(:processor_count).and_return(0)
    end

    it "does not raise any error" do
      expect do
        rule.run
        SemanticLogger.flush
      end.not_to output.to_stderr
    end

    context "when a notifier raises an error" do
      before do
        # mock emitters
        emitter = double("emitter_instance")
        allow(emitter).to receive(:valid?).and_return(true)
        allow(emitter).to receive(:result).and_return(Dry::Monads::Result::Failure.new("error"))
        # set mocked classes as emitters
        allow(rule).to receive(:valid_emitters).and_return([emitter])
        allow(rule).to receive(:enriched_artifacts).and_return([
          Mihari::Models::Artifact.new(data: "1.1.1.1")
        ])
        allow(Parallel).to receive(:processor_count).and_return(0)
      end

      it do
        rule.run

        # read logger output
        SemanticLogger.flush
        sio.rewind
        output = sio.read

        expect(output).to include("Emission by")
      end
    end
  end
end
