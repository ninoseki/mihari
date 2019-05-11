# frozen_string_literal: true

RSpec.describe Mihari::CLI do
  let(:query) { "test" }
  let(:mock) { double("Analyzer") }

  subject { described_class }

  before { allow(mock).to receive(:run) }

  describe "#censys" do
    before { allow(Mihari::Analyzers::Censys).to receive(:new).and_return(mock) }

    it do
      subject.start ["censys", query]
      expect(mock).to have_received(:run).once
    end
  end

  describe "#shodan" do
    before { allow(Mihari::Analyzers::Shodan).to receive(:new).and_return(mock) }

    it do
      subject.start ["shodan", query]
      expect(mock).to have_received(:run).once
    end
  end

  describe "#onyphe" do
    before { allow(Mihari::Analyzers::Onyphe).to receive(:new).and_return(mock) }

    it do
      subject.start ["onyphe", query]
      expect(mock).to have_received(:run).once
    end
  end
end
