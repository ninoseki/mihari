# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::PassiveSSL do
  subject { described_class.new(query, tags: tags) }

  let(:tags) { %w(test) }

  let(:query) { "7c552ab044c76d1df4f5ddf358807bfdcd07fa57" }
  let(:mock) { instance_double("Analyzer") }

  before do
    allow(mock).to receive(:artifacts).and_return([])

    allow(Mihari::Analyzers::CIRCL).to receive(:new).and_return(mock)
    allow(Mihari::Analyzers::PassiveTotal).to receive(:new).and_return(mock)
  end

  describe "#title" do
    it do
      expect(subject.title).to eq("PassiveSSL cross search")
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
