# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Basic, :vcr do
  let(:title) { "test" }
  let(:description) { "test" }
  let(:artifacts) { %w(1.1.1.1) }
  let(:tags) { %w(test) }

  subject { described_class.new(title: title, description: description, artifacts: artifacts, tags: tags) }

  describe "#title" do
    it do
      expect(subject.title).to eq(title)
    end
  end

  describe "#description" do
    it do
      expect(subject.description).to eq(description)
    end
  end

  describe "#artifacts" do
    it do
      expect(subject.artifacts).to eq(artifacts)
    end
  end

  describe "#tags" do
    it do
      expect(subject.tags).to eq(tags)
    end
  end
end
