# frozen_string_literal: true

RSpec.describe Mihari::Services::AlertProxy do
  let(:data) do
    {
      rule_id: SecureRandom.uuid,
      artifacts: ["example.com", "1.1.1.1"]
    }
  end
  let(:alert) { described_class.new(**data) }

  describe "#errors?" do
    it "doesn't have any errors" do
      expect(alert.errors?).to be false
    end
  end

  describe "#rule" do
    it "raises ActiveRecord::RecordNotFound" do
      expect { alert.rule }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context "with database fixture" do
    include_context "with database fixtures"

    let(:rule) { Mihari::Models::Rule.first }
    let(:data) do
      {
        rule_id: rule.id,
        artifacts: ["example.com", "1.1.1.1"]
      }
    end
    let(:alert) { described_class.new(**data) }

    describe "#rule" do
      it "doesn't raise ActiveRecord::RecordNotFound" do
        expect(alert.rule).to be_a Mihari::Rule
      end
    end
  end
end
