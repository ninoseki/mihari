# frozen_string_literal: true

require "yaml"

RSpec.describe Mihari::Structs::Rule do
  let(:data) do
    {
      id: "foo",
      description: "foo",
      title: "foo",
      queries: [
        { analyzer: "shodan", query: "foo" }
      ],
      allowed_data_types: ["ip"]
    }
  end
  let(:rule) { described_class.new(data) }

  describe "#errors?" do
    it "should not have any errors" do
      expect(rule.errors?).to eq(false)
    end
  end

  describe "#analyzer" do
    it "should return an analyzer" do
      expect(rule.analyzer).to be_a Mihari::Analyzers::Rule
    end
  end
end
