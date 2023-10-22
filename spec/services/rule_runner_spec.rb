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
  let!(:proxy) { Mihari::Services::RuleProxy.new(data) }
  let!(:runner) { Mihari::Services::RuleRunner.new(proxy) }

  describe "#diff?" do
    it do
      expect(runner.diff?).to be false
    end
  end
end
