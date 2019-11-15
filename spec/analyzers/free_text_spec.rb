# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::FreeText do
  subject { described_class.new(query, tags: tags) }

  let(:tags) { %w(test) }
  let(:query) { "foo bar" }

  let(:mock) { instance_double("Analyzer") }

  before do
    allow(mock).to receive(:artifacts).and_return([])

    allow(Mihari::Analyzers::BinaryEdge).to receive(:new).with(query).and_return(mock)
    allow(Mihari::Analyzers::Censys).to receive(:new).with(query).and_return(mock)
  end

  describe "#title" do
    it do
      expect(subject.title).to eq("Free text cross search")
    end
  end

  describe "#description" do
    it do
      expect(subject.description).to eq("query = #{query}")
    end
  end

  describe "#artifacts" do
    before do
      allow(Parallel).to receive(:processor_count).and_return(0)
    end

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
