# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::SHA256 do
  subject { described_class.new(query, tags: tags) }

  let(:tags) { %w(test) }

  let(:query) { "275a021bbfb6489e54d471899f7db9d1663fc695ec2fe2a2c4538aabf651fd0f" }
  let(:mock) { instance_double("Analyzer") }

  before do
    allow(mock).to receive(:artifacts).and_return([])

    allow(Mihari::Analyzers::BinaryEdge).to receive(:new).and_return(mock)
    allow(Mihari::Analyzers::Censys).to receive(:new).and_return(mock)
  end

  describe "#title" do
    it do
      expect(subject.title).to eq("SHA256 hash cross search")
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
