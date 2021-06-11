# frozen_string_literal: true

require "yaml"
require "active_support/core_ext/hash"

def symbolize_data(data)
  data.symbolize_keys!

  queries = data[:queries]
  queries.each(&:symbolize_keys!)

  data
end

RSpec.describe Mihari::Schemas::Rule do
  let(:contract) { Mihari::Schemas::RuleContract.new }

  context "with valid rule" do
    it do
      result = contract.call(description: "foo", title: "foo", queries: [{ service: "shodan", query: "foo" }])
      expect(result.errors.empty?).to eq(true)
    end

    it do
      result = contract.call(
        description: "foo",
        title: "foo",
        queries: [
          { service: "shodan", query: "foo" },
          { service: "crtsh", query: "foo", exclude_expired: true },
          { service: "zoomeye", query: "foo", type: "host" }
        ]
      )
      expect(result.errors.empty?).to eq(true)
    end

    it do
      result = contract.call(
        description: "foo",
        title: "foo",
        queries: [
          { service: "shodan", query: "foo" }
        ],
        allowed_data_types: ["ip"]
      )
      expect(result.errors.empty?).to eq(true)
    end
  end

  context "with invalid service name" do
    it do
      expect { contract.call(description: "foo", title: "foo", queries: [{ service: "foo", query: "foo" }]) }.to raise_error(NoMethodError)
    end

    it do
      expect do
        contract.call(
          description: "foo",
          title: "foo",
          queries: [
            { service: "shodan", query: "foo" },
            { service: "crtsh", query: "foo", exclude_expired: 1 }, # should be bool
            { service: "zoomeye", query: "foo", type: "bar" } # should be any of host or web
          ]
        )
      end.to raise_error(NoMethodError)
    end

    it do
      result = contract.call(
        description: "foo",
        title: "foo",
        queries: [
          { service: "shodan", query: "foo" }
        ],
        allowed_data_types: ["foo"] # should be any of ip, domain, mail, url or hash
      )
      expect(result.errors.empty?).to eq(false)
    end
  end
end
