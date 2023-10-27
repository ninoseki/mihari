# frozen_string_literal: true

RSpec.describe Mihari::Emitters::Database do
  subject { described_class.new(artifacts: artifacts, rule: rule) }

  include_context "with database fixtures"

  let(:rule) { Mihari::Rule.from_model(Mihari::Models::Rule.first) }
  let(:artifacts) { [Mihari::Models::Artifact.new(data: "1.1.1.1")] }

  describe "#emit", vcr: "Mihari_Enrichers_IPInfo/ip:1.1.1.1" do
    it do
      alert = subject.emit
      expect(alert).to be_a(Mihari::Models::Alert)

      created_artifacts = Mihari::Models::Artifact.where(alert_id: alert.id)
      expect(created_artifacts.length).to eq(artifacts.length)
    end

    it "does not create duplications" do
      subject.emit
      subject.emit

      expect(Mihari::Models::Tag.where(name: rule.tags.first).count).to eq(1)
    end
  end
end
