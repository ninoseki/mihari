# frozen_string_literal: true

require "yaml"

RSpec.describe Mihari::Services::RuleProxy do
  let!(:data) do
    {
      id: SecureRandom.uuid,
      description: "foo",
      title: "foo",
      queries: [
        { analyzer: "shodan", query: "foo" }
      ],
      allowed_data_types: ["ip"]
    }
  end
  let!(:rule) { described_class.new(data) }

  describe "#errors?" do
    it "doesn't have any errors" do
      expect(rule.errors?).to be false
    end
  end

  describe "#to_analyzer" do
    it "returns an analyzer" do
      expect(rule.analyzer).to be_a Mihari::Rule
    end
  end

  describe "#to_model" do
    it "returns a model" do
      expect(rule.model).to be_a Mihari::Models::Rule
    end
  end
end
