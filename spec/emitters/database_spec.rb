# frozen_string_literal: true

RSpec.describe Mihari::Emitters::Database do
  subject(:emitter) { described_class.new(rule: rule) }

  include_context "with database fixtures"

  let!(:rule) { Mihari::Rule.from_model(Mihari::Models::Rule.first) }
  let!(:artifacts) { [Mihari::Models::Artifact.new(data: "1.1.1.1")] }

  describe "#call", vcr: "Mihari_Enrichers_IPInfo/ip:1.1.1.1" do
    it do
      alert = emitter.call artifacts
      expect(alert).to be_a(Mihari::Models::Alert)

      created_artifacts = Mihari::Models::Artifact.where(alert_id: alert.id)
      expect(created_artifacts.length).to eq(artifacts.length)
    end

    it "does not create duplications" do
      2.times { emitter.call artifacts }

      expect(Mihari::Models::Tag.where(name: rule.tags.first).count).to eq(1)
    end
  end
end
