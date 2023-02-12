# frozen_string_literal: true

RSpec.describe Mihari::Emitters::Database do
  subject { described_class.new }

  include_context "with database fixtures"

  describe "#emit", vcr: "Mihari_Enrichers_IPInfo/ip:1.1.1.1" do
    let(:rule) { Mihari::Structs::Rule.from_model(Mihari::Rule.first) }
    let(:artifacts) { [Mihari::Artifact.new(data: "1.1.1.1")] }

    it do
      alert = subject.emit(artifacts: artifacts, rule: rule)
      expect(alert).to be_a(Mihari::Alert)

      created_artifacts = Mihari::Artifact.where(alert_id: alert.id)
      expect(created_artifacts.length).to eq(artifacts.length)
    end

    it "does not create multi tags" do
      subject.emit(artifacts: artifacts, rule: rule)
      subject.emit(artifacts: artifacts, rule: rule)

      expect(Mihari::Tag.where(name: rule.tags.first).count).to eq(1)
    end
  end
end
