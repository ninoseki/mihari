# frozen_string_literal: true

RSpec.describe Mihari::Services::AlertProxy do
  let_it_be(:rule) { FactoryBot.create(:rule) }
  let_it_be(:data) do
    {
      rule_id: rule.id,
      artifacts: []
    }
  end
  let(:alert) { described_class.new(**data) }

  describe "#rule" do
    it "doesn't raise ActiveRecord::RecordNotFound" do
      expect(alert.rule).to be_a Mihari::Rule
    end
  end

  context "without a saved rule" do
    let(:data) do
      {
        rule_id: Faker::Internet.unique.uuid,
        artifacts: []
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
  end
end
