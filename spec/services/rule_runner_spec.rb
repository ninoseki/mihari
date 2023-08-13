# frozen_string_literal: true

require "yaml"

RSpec.describe Mihari::Services::RuleRunner do
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

  let(:proxy) { Mihari::Services::RuleProxy.new(data) }

  let(:force_overwrite) { true }

  let(:rule) { Mihari::Services::RuleRunner.new(proxy, force_overwrite: force_overwrite) }

  describe "#force_overwrite?" do
    it "should return the same value" do
      expect(rule.force_overwrite?).to eq force_overwrite
    end
  end
end
