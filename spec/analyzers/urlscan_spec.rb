# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Urlscan, :vcr do
  subject { described_class.new(query, tags: tags) }

  let(:query) { "e07f9491ce7429e8eee6d00df76b8cc1ffefc010050bba24fa994a74813276fb" }
  let(:tags) { %w(test) }

  describe "#title" do
    it do
      expect(subject.title).to eq("urlscan lookup")
    end
  end

  describe "#description" do
    it do
      expect(subject.description).to eq("query = #{query}")
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
