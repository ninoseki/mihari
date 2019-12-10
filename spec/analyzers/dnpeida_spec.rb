# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::DNPedia, :vcr do
  subject { described_class.new(query, tags: tags) }

  let(:tags) { %w(test) }
  let(:query) { "%apple%" }

  describe "#artifacts" do
    it do
      expect(subject.artifacts).to be_an(Array)
    end
  end

  describe "#title" do
    it do
      expect(subject.title).to eq("DNPedia domain lookup")
    end
  end

  describe "#description" do
    it do
      expect(subject.description).to eq("query = #{query}")
    end
  end
end
