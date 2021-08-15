# frozen_string_literal: true

RSpec.describe Mihari::Emitters::Database do
  subject { described_class.new }

  after do
    reset_db
  end

  describe "#emit" do
    let(:title) { "test" }
    let(:description) { "test" }
    let(:artifacts) { [Mihari::Artifact.new(data: "1.1.1.1")] }
    let(:source) { "test" }
    let(:tags) { %w[test] }

    it do
      alert = subject.emit(title: title, description: description, artifacts: artifacts, source: source, tags: tags)
      expect(alert).to be_a(Mihari::Alert)

      created_artifacts = Mihari::Artifact.where(alert_id: alert.id)
      expect(created_artifacts.length).to eq(artifacts.length)
    end

    it "does not create multi tags" do
      subject.emit(title: title, description: description, artifacts: artifacts, source: source, tags: tags)
      subject.emit(title: title, description: description, artifacts: artifacts, source: source, tags: tags)

      expect(Mihari::Tag.where(name: "test").count).to eq(1)
    end
  end
end
