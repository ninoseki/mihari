# frozen_string_literal: true

RSpec.describe Mihari::TheHive::Artifact, :vcr do
  subject { described_class.new }

  describe "#exists?" do
    context "when give a not existing value" do
      it do
        expect(subject.exists?(data: "null.example.com", data_type: "domain")).to be(false)
      end
    end

    context "when give an existing value" do
      it do
        expect(subject.exists?(data: "1.1.1.1", data_type: "ip")).to be(true)
      end
    end
  end

  describe "#find_non_existing_artifacts" do
    let(:existing_artifacts) {
      [
        Mihari::Artifact.new("1.1.1.1"),
        Mihari::Artifact.new("github.com"),
      ]
    }
    let(:non_existing_artifacts) {
      [
        Mihari::Artifact.new("http://example.com"),
        Mihari::Artifact.new("44d88612fea8a8f36de82e1278abb02f"),
        Mihari::Artifact.new("example@gmail.com")
      ]
    }
    let(:artifacts) { existing_artifacts + non_existing_artifacts }

    it do
      filtered_artifacts = subject.find_non_existing_artifacts(artifacts)
      expect(filtered_artifacts.map(&:data).sort).to eq(non_existing_artifacts.map(&:data).sort)
    end
  end
end
