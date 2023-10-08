# frozen_string_literal: true

RSpec.describe Mihari::Schemas::RuleContract do
  let!(:contract) { Mihari::Schemas::RuleContract.new }
  let!(:id) { "test" }
  let!(:description) { "test" }
  let!(:title) { "test" }

  context "with valid rule" do
    describe "rule should have default values" do
      it do
        result = contract.call(
          id: id,
          description: description,
          title: title,
          queries: [{ analyzer: "shodan", query: "foo" }]
        )

        expect(result[:enrichers].length).to eq Mihari::DEFAULT_ENRICHERS.length
        expect(result[:emitters].length).to eq Mihari::DEFAULT_EMITTERS.length
        expect(result[:data_types].length).to eq Mihari::DEFAULT_DATA_TYPES.length

        expect(result[:tags].length).to eq 0
      end
    end

    context "analyzers that do not need additional options" do
      it do
        analyzers = Mihari::Analyzers::ANALYZER_TO_CLASS.keys - %w[zoomeye crtsh feed hunterhow]

        analyzers.each do |analyzer|
          result = contract.call(
            id: id,
            description: description,
            title: title,
            queries: [{ analyzer: analyzer, query: "foo" }]
          )
          expect(result.errors.empty?).to be true
        end
      end
    end

    context "analyzers that need additional options" do
      it do
        result = contract.call(
          id: id,
          description: description,
          title: title,
          queries: [
            { analyzer: "crtsh", query: "foo", exclude_expired: true },
            { analyzer: "zoomeye", query: "foo", type: "host" },
            { analyzer: "zoomeye", query: "foo", type: "host", options: { interval: 10 } }
          ]
        )
        expect(result.errors.empty?).to be true
      end
    end

    context "with allowed_data_types" do
      it do
        result = contract.call(
          id: id,
          description: description,
          title: title,
          queries: [
            { analyzer: "shodan", query: "foo" }
          ],
          data_types: ["ip"]
        )
        expect(result.errors.empty?).to be true
      end
    end
  end

  context "with invalid analyzer name" do
    it do
      result = contract.call(
        id: id,
        description: description,
        title: title,
        queries: [{ analyzer: "foo", query: "foo" }]
      )
      expect(result.errors.empty?).to be false
    end

    it do
      result = contract.call(
        id: id,
        description: description,
        title: title,
        queries: [
          { analyzer: "shodan", query: "foo" },
          { analyzer: "crtsh", query: "foo", exclude_expired: 1 }, # should be bool
          { analyzer: "zoomeye", query: "foo", type: "bar" } # should be any of host or web
        ]
      )
      expect(result.errors.empty?).to be false
    end
  end

  context "with invalid data types" do
    it do
      result = contract.call(
        id: id,
        description: description,
        title: title,
        queries: [
          { analyzer: "shodan", query: "foo" }
        ],
        data_types: ["foo"] # should be any of ip, domain, mail, url or hash
      )
      expect(result.errors.empty?).to be false
    end
  end

  context "with invalid disallowed data values" do
    it do
      result = contract.call(
        id: id,
        description: description,
        title: title,
        queries: [
          { analyzer: "shodan", query: "foo" }
        ],
        falsepositives: [1] # should be string
      )
      expect(result.errors.empty?).to be false
    end

    it do
      result = contract.call(
        id: id,
        description: description,
        title: title,
        queries: [
          { analyzer: "shodan", query: "foo" }
        ],
        falsepositives: ["/*/"]
      )
      expect(result.errors.empty?).to be false
    end
  end

  context "with invalid artifact_lifetime" do
    it do
      result = contract.call(
        id: id,
        description: description,
        title: title,
        queries: [
          { analyzer: "shodan", query: "foo" }
        ],
        artifact_lifetime: "foo" # should be an integer
      )
      expect(result.errors.empty?).to be false
    end
  end

  context "with invalid emitter name" do
    it do
      result = contract.call(
        id: id,
        description: description,
        title: title,
        queries: [
          { analyzer: "shodan", query: "foo" }
        ],
        emitters: [
          { emitter: "foo" }
        ]
      )
      expect(result.errors.empty?).to be false
    end
  end
end
