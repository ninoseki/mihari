# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Shodan, :vcr do
  let(:query) { "dev.min.js" }

  subject { described_class.new(query) }

  describe "#title" do
    it do
      expect(subject.title).to eq("Shodan lookup")
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
end
