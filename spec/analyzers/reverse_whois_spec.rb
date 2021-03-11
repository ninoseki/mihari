# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::ReveseWhois do
  subject { described_class.new(query, tags: tags) }

  let(:tags) { %w[test] }

  let(:query) { "test@test.com" }
  let(:mock) { instance_double("Analyzer") }

  before do
    allow(mock).to receive(:artifacts).and_return([])

    allow(Mihari::Analyzers::PassiveTotal).to receive(:new).and_return(mock)
    allow(Mihari::Analyzers::SecurityTrails).to receive(:new).and_return(mock)
  end

  describe "#title" do
    it do
      expect(subject.title).to eq("ReveseWhois cross search")
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
