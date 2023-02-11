# frozen_string_literal: true

RSpec.describe Mihari::Emitters::Database do
  subject { described_class.new }

  include_context "with database fixtures"

  after do
    reset_db
  end

  describe "#emit", vcr: "Mihari_Enrichers_IPInfo/ip:1.1.1.1" do
    let(:title) { "test" }
    let(:description) { "test" }
    let(:artifacts) { [Mihari::Artifact.new(data: "1.1.1.1")] }
    let(:rule_id) { Mihari::Rule.first.id }
    let(:tags) { %w[test] }

    it do
      alert = subject.emit(title: title, description: description, artifacts: artifacts, rule_id: rule_id, tags: tags)
      expect(alert).to be_a(Mihari::Alert)

      created_artifacts = Mihari::Artifact.where(alert_id: alert.id)
      expect(created_artifacts.length).to eq(artifacts.length)
    end

    it "does not create multi tags" do
      subject.emit(title: title, description: description, artifacts: artifacts, rule_id: rule_id, tags: tags)
      subject.emit(title: title, description: description, artifacts: artifacts, rule_id: rule_id, tags: tags)

      expect(Mihari::Tag.where(name: "test").count).to eq(1)
    end
  end
end
