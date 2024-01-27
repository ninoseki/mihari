# frozen_string_literal: true

RSpec.describe Mihari::Rule do
  include_context "with mocked logger"

  let!(:id) { "test" }
  let!(:title) { "test" }
  let!(:description) { "test" }
  let(:queries) { [] }
  let!(:tags) { %w[test] }
  let(:falsepositives) { [] }
  let(:data_types) { Mihari::DEFAULT_DATA_TYPES }
  let!(:emitters) { [{emitter: "database"}] }
  let!(:created_on) { Date.today }
  let!(:updated_on) { Date.today }
  let!(:artifact_ttl) { 0 }
  let(:rule) do
    described_class.new(
      title:,
      description:,
      tags:,
      queries:,
      id:,
      data_types:,
      falsepositives:,
      emitters:,
      created_on:,
      updated_on:,
      artifact_ttl:
    )
  end

  let_it_be(:artifacts) do
    FactoryBot.build_list(:artifact, 2, :domain)
  end

  let_it_be(:duplicated_artifacts) do
    artifact = FactoryBot.build(:artifact, :domain)
    [artifact, artifact]
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
    before do
      allow(rule).to receive(:artifacts).and_return(duplicated_artifacts)
    end

    describe "#normalized_artifacts" do
      it do
        expect(rule.normalized_artifacts).to be_an(Array)
      end

      it do
        expect(rule.normalized_artifacts.length).to eq(1)
      end
    end
  end

  context "with string false positive" do
    let(:falsepositives) { artifacts.map(&:data) }

    describe "#normalized_artifacts" do
      it do
        expect(rule.normalized_artifacts).to be_empty
      end
    end
  end

  context "with regexp false positive" do
    let(:falsepositives) { ["/[a-z.]+/"] }

    describe "#normalized_artifacts" do
      it do
        expect(rule.normalized_artifacts).to be_empty
      end
    end
  end

  context "with data types" do
    let(:data_types) { ["ip"] }

    describe "#normalized_artifacts" do
      it do
        expect(rule.normalized_artifacts).to be_empty
      end
    end
  end

  context "with an invalid analyzer" do
    let(:queries) do
      [
        {analyzer: "shodan", query: "foo"}
      ]
    end

    before do
      allow(Mihari.config).to receive(:shodan_api_key).and_return(nil)
    end

    it do
      expect do
        rule.artifacts
      end.to raise_error(Mihari::ConfigurationError, /Analyzer:shodan is not configured correctly/)
    end
  end

  describe "#call" do
    before do
      allow(rule).to receive(:emitters).and_return([])
      allow(rule).to receive(:enriched_artifacts).and_return([
        Mihari::Models::Artifact.new(data: Faker::Internet.ip_v4_address)
      ])
    end

    it "does not raise any error" do
      expect { rule.call }.not_to output.to_stderr
    end
  end

  describe "#diff" do
    before do
      rule.update_or_create
    end

    it do
      expect(rule.diff?).to eq(false)
    end

    context "with modified integer" do
      it do
        rule.tap { |rule| rule.data[:artifact_ttl] = -1 }
        expect(rule.diff?).to eq(true)
      end
    end

    context "with modified dates" do
      it do
        rule.tap { |rule| rule.data[:created_on] = Date.today.prev_day }
        expect(rule.diff?).to eq(true)
      end

      it do
        rule.tap { |rule| rule.data[:updated_on] = Date.today.prev_day }
        expect(rule.diff?).to eq(true)
      end
    end
  end
end
