# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Censys, :vcr do
  let(:query) { "sagawa.apk" }
  let(:tags) { %w(test) }

  subject { described_class.new(query, tags: tags) }

  describe "#title" do
    it do
      expect(subject.title).to eq("Censys lookup")
    end
  end

  describe "#description" do
    it do
      expect(subject.description).to eq("Query: #{query}")
    end
  end

  describe "#artifacts" do
    it do
      expect(subject.artifacts).to be_an(Array)
    end
  end

  describe "#tags" do
    it do
      expect(subject.tags).to eq(tags)
    end
  end
end
