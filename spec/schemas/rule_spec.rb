# frozen_string_literal: true

RSpec.describe Mihari::Schemas::RuleContract do
  let!(:contract) { described_class.new }
  let!(:id) { "test" }
  let!(:description) { "test" }
  let!(:title) { "test" }

  let(:queries) { [] }
  let(:emitters) { nil }
  let(:enrichers) { nil }
  let(:falsepositives) { nil }
  let(:data_types) { nil }
  let(:artifact_ttl) { nil }
  let(:data) do
    {
      id:,
      description:,
      title:,
      queries:,
      emitters:,
      enrichers:,
      falsepositives:,
      data_types:,
      artifact_ttl:
    }.compact
  end

  context "with valid rule" do
    it "has default values" do
      result = contract.call(**data)
      expect(result[:enrichers].length).to eq Mihari::DEFAULT_ENRICHERS.length
      expect(result[:emitters].length).to eq Mihari::DEFAULT_EMITTERS.length
      expect(result[:data_types].length).to eq Mihari::DEFAULT_DATA_TYPES.length
      expect(result[:tags].length).to eq 0
    end

    context "with analyzers don't need additional options" do
      let(:queries) do
        analyzers = Mihari.analyzer_to_class.keys - %w[zoomeye crtsh feed hunterhow]
        analyzers.map do |analyzer|
          {analyzer:, query: "foo"}
        end
      end

      it do
        result = contract.call(**data)
        expect(result.errors.empty?).to be true
      end
    end

    context "with analyzers need additional options" do
      let(:queries) do
        [
          {analyzer: "crtsh", query: "foo", exclude_expired: true},
          {analyzer: "zoomeye", query: "foo", type: "host"},
          {analyzer: "zoomeye", query: "foo", type: "host", options: {interval: 10}}
        ]
      end

      it do
        result = contract.call(**data)
        expect(result.errors.empty?).to be true
      end
    end

    context "with allowed_data_types" do
      let(:data_types) { ["ip"] }

      it do
        result = contract.call(**data)
        expect(result.errors.empty?).to be true
      end
    end
  end

  context "with invalid analyzer name" do
    let(:queries) { [{analyzer: "foo", query: "foo"}] }

    it do
      result = contract.call(**data)
      expect(result.errors.empty?).to be false
    end
  end

  context "with invalid options" do
    let(:queries) do
      [
        {analyzer: "shodan", query: "foo"},
        {analyzer: "crtsh", query: "foo", exclude_expired: 1}, # should be bool
        {analyzer: "zoomeye", query: "foo", type: "bar"} # should be any of host or web
      ]
    end

    it do
      result = contract.call(**data)
      expect(result.errors.empty?).to be false
    end
  end

  context "with invalid data types" do
    let(:data_types) do
      # should be any of ip, domain, mail, url or hash
      ["foo"]
    end

    it do
      result = contract.call(**data)
      expect(result.errors.empty?).to be false
    end
  end

  context "with non-string falsepositives values" do
    let(:falsepositives) do
      # should be string
      [1]
    end

    it do
      result = contract.call(**data)
      expect(result.errors.empty?).to be false
    end
  end

  context "with non-string falsepositives values" do
    let(:falsepositives) do
      # /*/ is not compilable as a regexp
      ["/*/"]
    end

    it do
      result = contract.call(**data)
      expect(result.errors.empty?).to be false
    end
  end

  context "with invalid artifact_ttl" do
    let(:artifact_ttl) { "foo " }

    it do
      result = contract.call(**data)
      expect(result.errors.empty?).to be false
    end
  end

  context "with invalid emitter name" do
    let(:emitters) { [{emitter: "foo"}] }

    it do
      result = contract.call(**data)
      expect(result.errors.empty?).to be false
    end
  end

  context "without having database emitter" do
    let(:emitters) { [{emitter: "misp"}] }

    it do
      result = contract.call(**data)
      expect(result.errors.to_h).to eq({emitters: ["Emitter:database should be included in emitters"]})
    end
  end
end
