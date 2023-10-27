# frozen_string_literal: true

require "yaml"

RSpec.describe Mihari::Services::RuleRunner do
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
  let!(:rule) { Mihari::Rule.new(**data) }
  let!(:runner) { Mihari::Services::RuleRunner.new(rule) }

  describe "#diff?" do
    it do
      expect(runner.diff?).to be false
    end
  end
end
