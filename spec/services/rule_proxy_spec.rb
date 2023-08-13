# frozen_string_literal: true

require "yaml"

RSpec.describe Mihari::Services::RuleProxy do
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
      expect(rule.errors?).to be false
    end
  end

  describe "#to_analyzer" do
    it "should return an analyzer" do
      expect(rule.to_analyzer).to be_a Mihari::Analyzers::Rule
    end
  end

  describe "#to_model" do
    it "should return a model" do
      expect(rule.to_model).to be_a Mihari::Rule
    end
  end
end
