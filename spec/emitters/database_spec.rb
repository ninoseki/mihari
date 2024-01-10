# frozen_string_literal: true

RSpec.describe Mihari::Emitters::Database do
  subject(:emitter) { described_class.new(rule: rule) }

  let_it_be(:rule) { Mihari::Rule.from_model FactoryBot.create(:rule) }
  let!(:artifacts) { [Mihari::Models::Artifact.new(data: "1.1.1.1")] }

  describe "#call" do
    let!(:alert) { emitter.call artifacts }

    it do
      expect(alert).to be_a(Mihari::Models::Alert)
    end

    it do
      created_artifacts = Mihari::Models::Artifact.where(alert_id: alert.id)
      expect(created_artifacts.length).to eq(artifacts.length)
    end
  end

  describe "#target" do
    it do
      expect(emitter.target).to eq("sqlite3::memory:")
    end
  end
end
