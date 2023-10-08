# frozen_string_literal: true

RSpec.describe Mihari::Emitters::Database do
  include_context "with database fixtures"

  let(:rule) { Mihari::Services::RuleProxy.from_model(Mihari::Rule.first) }
  let(:artifacts) { [Mihari::Artifact.new(data: "1.1.1.1")] }

  subject { described_class.new(artifacts: artifacts, rule: rule) }

  describe "#emit", vcr: "Mihari_Enrichers_IPInfo/ip:1.1.1.1" do
    it do
      alert = subject.emit
      expect(alert).to be_a(Mihari::Alert)

      created_artifacts = Mihari::Artifact.where(alert_id: alert.id)
      expect(created_artifacts.length).to eq(artifacts.length)
    end

    it "should not create duplications" do
      subject.emit
      subject.emit

      expect(Mihari::Tag.where(name: rule.tags.first).count).to eq(1)
    end
  end
end
