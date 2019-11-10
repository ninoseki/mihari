# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::PassiveDNS do
  subject { described_class.new(query, tags: tags) }

  let(:tags) { %w(test) }

  let(:query) { "test" }
  let(:mock) { instance_double("Analyzer") }

  before do
    allow(mock).to receive(:artifacts).and_return([])

    allow(Mihari::Analyzers::CIRCL).to receive(:new).and_return(mock)
    allow(Mihari::Analyzers::PassiveTotal).to receive(:new).and_return(mock)
    allow(Mihari::Analyzers::SecurityTrails).to receive(:new).and_return(mock)
    allow(Mihari::Analyzers::VirusTotal).to receive(:new).and_return(mock)
  end

  context "when given an ipv4" do
    let(:query) { "89.35.39.84" }

    describe "#title" do
      it do
        expect(subject.title).to eq("PassiveDNS cross search")
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

  context "when given a domain" do
    let(:query) { "jppost-tu.top" }

    describe "#artifacts" do
      it do
        expect(subject.artifacts).to be_an(Array)
      end
    end
  end
end
