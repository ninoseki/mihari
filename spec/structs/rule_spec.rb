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
  let(:yaml) { data.to_yaml }
  let(:rule) { described_class.new(data, yaml) }

  describe "#errors?" do
    it "should not have any errors" do
      expect(rule.errors?).to eq(false)
    end
  end

  describe "#to_analyzer" do
    it "should return an analyzer" do
      expect(rule.to_analyzer).to be_a Mihari::Analyzers::Rule
    end
  end
end
