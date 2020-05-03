# frozen_string_literal: true

require "json"

RSpec.describe Mihari::Emitters::StandardOutput do
  subject { described_class.new }

  describe "#emit" do
    let(:title) { "title" }
    let(:description) { "description" }
    let(:artifacts) {
      [
        Mihari::Artifact.new(data: "1.1.1.1"),
        Mihari::Artifact.new(data: "github.com"),
        Mihari::Artifact.new(data: "http://example.com"),
        Mihari::Artifact.new(data: "44d88612fea8a8f36de82e1278abb02f"),
        Mihari::Artifact.new(data: "example@gmail.com")
      ]
    }
    let(:source) { "test" }
    let(:tags) { [] }

    it do
      stdout = capture(:stdout) { subject.emit(title: title, description: description, artifacts: artifacts, source: source, tags: tags) }
      json = JSON.parse(stdout)
      expect(json).to be_a(Hash)
    end
  end
end
