# frozen_string_literal: true

require "yaml"

RSpec.describe Mihari::Services::AlertProxy do
  let(:data) do
    {
      rule_id: "foo",
      artifacts: ["example.com", "1.1.1.1"]
    }
  end
  let(:alert) { described_class.new(data) }

  describe "#errors?" do
    it "should not have any errors" do
      expect(alert.errors?).to be false
    end
  end

  describe "#rule" do
    it "should raise not found error" do
      expect { alert.rule }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context "with database fixture" do
    include_context "with database fixtures"

    let(:rule) { Mihari::Rule.first }
    let(:data) do
      {
        rule_id: rule.id,
        artifacts: ["example.com", "1.1.1.1"]
      }
    end
    let(:alert) { described_class.new(data) }

    describe "#rule" do
      it "should not raise not found error" do
        rule = alert.rule
        expect(rule).to be_a Mihari::Services::RuleProxy
      end
    end
  end
end
