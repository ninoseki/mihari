# frozen_string_literal: true

RSpec.describe Mihari::Schemas::RuleContract do
  let(:contract) { Mihari::Schemas::RuleContract.new }

  context "with valid rule" do
    context "analyzers does not need additional options" do
      it do
        analyzers = Mihari::Analyzers::ANALYZER_TO_CLASS.keys - ["spyse", "zoomeye", "crtsh"]

        analyzers.each do |analyzer|
          result = contract.call(description: "foo", title: "foo", queries: [{ analyzer: analyzer, query: "foo" }])
          expect(result.errors.empty?).to eq(true)
        end
      end
    end

    context "analyzers needs additonal options" do
      it do
        result = contract.call(
          description: "foo",
          title: "foo",
          queries: [
            { analyzer: "crtsh", query: "foo", exclude_expired: true },
            { analyzer: "spyse", query: "foo", type: "ip" },
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
          description: "foo",
          title: "foo",
          queries: [
            { analyzer: "shodan", query: "foo" }
          ],
          allowed_data_types: ["ip"]
        )
        expect(result.errors.empty?).to eq(true)
      end
    end
  end

  context "with invalid analyzer name" do
    it do
      expect { contract.call(description: "foo", title: "foo", queries: [{ analyzer: "foo", query: "foo" }]) }.to raise_error(NoMethodError)
    end

    it do
      expect do
        contract.call(
          description: "foo",
          title: "foo",
          queries: [
            { analyzer: "shodan", query: "foo" },
            { analyzer: "crtsh", query: "foo", exclude_expired: 1 }, # should be bool
            { analyzer: "zoomeye", query: "foo", type: "bar" } # should be any of host or web
          ]
        )
      end.to raise_error(NoMethodError)
    end
  end

  context "with invalid allowed data types" do
    it do
      result = contract.call(
        description: "foo",
        title: "foo",
        queries: [
          { analyzer: "shodan", query: "foo" }
        ],
        allowed_data_types: ["foo"] # should be any of ip, domain, mail, url or hash
      )
      expect(result.errors.empty?).to eq(false)
    end
  end

  context "with invalid disallowed data values" do
    it do
      result = contract.call(
        description: "foo",
        title: "foo",
        queries: [
          { analyzer: "shodan", query: "foo" }
        ],
        disallowed_data_values: [1] # should be string
      )
      expect(result.errors.empty?).to eq(false)
    end

    it do
      result = contract.call(
        description: "foo",
        title: "foo",
        queries: [
          { analyzer: "shodan", query: "foo" }
        ],
        disallowed_data_values: ["/*/"]
      )
      expect(result.errors.empty?).to eq(false)
    end
  end

  context "with invalid ignore_old_artifacts" do
    it do
      result = contract.call(
        description: "foo",
        title: "foo",
        queries: [
          { analyzer: "shodan", query: "foo" }
        ],
        ignore_old_artifacts: "foo" # should be boolean (true or false)
      )
      expect(result.errors.empty?).to eq(false)
    end
  end

  context "with invalid ignore_threshold" do
    it do
      result = contract.call(
        description: "foo",
        title: "foo",
        queries: [
          { analyzer: "shodan", query: "foo" }
        ],
        ignore_threshold: "foo" # should be integer
      )
      expect(result.errors.empty?).to eq(false)
    end
  end

  context "with invalid options" do
    it do
      expect do
        contract.call(
          description: "foo",
          title: "foo",
          queries: [
            { analyzer: "shodan", query: "foo", options: { interval: "foo" } }
          ]
        )
      end.to raise_error(NoMethodError)
    end
  end

  context "with invalid emitter name" do
    it do
      expect do
        contract.call(
          description: "foo",
          title: "foo",
          queries: [
            { analyzer: "shodan", query: "foo" }
          ],
          emitters: [
            { emitter: "foo" }
          ]
        )
      end.to raise_error(NoMethodError)
    end
  end
end
