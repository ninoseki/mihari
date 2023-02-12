# frozen_string_literal: true

RSpec.describe Mihari::Schemas::RuleContract do
  let(:contract) { Mihari::Schemas::RuleContract.new }
  let(:id) { "test" }
  let(:description) { "test" }
  let(:title) { "test" }

  context "with valid rule" do
    context "analyzers does not need additional options" do
      it do
        analyzers = Mihari::Analyzers::ANALYZER_TO_CLASS.keys - %w[zoomeye crtsh feed]

        analyzers.each do |analyzer|
          result = contract.call(
            id: id,
            description: description,
            title: title,
            queries: [{ analyzer: analyzer, query: "foo" }]
          )
          expect(result.errors.empty?).to eq(true)
        end
      end
    end

    context "analyzers needs additonal options" do
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
        expect(result.errors.empty?).to eq(true)
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
        expect(result.errors.empty?).to eq(true)
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
      expect(result.errors.empty?).to eq(false)
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
      expect(result.errors.empty?).to eq(false)
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
      expect(result.errors.empty?).to eq(false)
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
        disallowed_data_values: [1] # should be string
      )
      expect(result.errors.empty?).to eq(false)
    end

    it do
      result = contract.call(
        id: id,
        description: description,
        title: title,
        queries: [
          { analyzer: "shodan", query: "foo" }
        ],
        disallowed_data_values: ["/*/"]
      )
      expect(result.errors.empty?).to eq(false)
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
      expect(result.errors.empty?).to eq(false)
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
      expect(result.errors.empty?).to eq(false)
    end
  end
end
