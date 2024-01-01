# frozen_string_literal: true

RSpec.describe Mihari::Services::RuleBuilder do
  let_it_be(:rule) { FactoryBot.create(:rule) }

  describe "#call" do
    context "with ID (database)" do
      it do
        expect(described_class.call(rule.id)).to be_a(Mihari::Rule)
      end
    end

    context "with path (file)" do
      let!(:path) { File.expand_path("../fixtures/rules/valid_rule.yml", __dir__) }

      it do
        expect(described_class.call(path)).to be_a(Mihari::Rule)
      end
    end
  end
end
