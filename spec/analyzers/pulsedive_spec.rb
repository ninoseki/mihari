# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Pulsedive, :vcr do
  subject(:analyzer) { described_class.new(query) }

  context "with ip" do
    let(:query) { "1.1.1.1" }

    describe "#artifacts" do
      it do
        expect(analyzer.artifacts).to be_an(Array)
      end
    end
  end

  context "with domain" do
    let(:query) { "one.one.one.one" }

    describe "#artifacts" do
      it do
        expect(analyzer.artifacts).to be_an(Array)
      end
    end
  end

  context "with invalid input" do
    let(:query) { "foo bar" }

    describe "#artifacts" do
      it do
        expect { analyzer.artifacts }.to raise_error(Mihari::ValueError)
      end
    end
  end

  context "without API credentials" do
    let(:query) { "1.1.1.1" }

    before do
      allow(Mihari.config).to receive(:pulsedive_api_key).and_return(nil)
    end

    it do
      expect { analyzer.artifacts }.to raise_error(ArgumentError)
    end
  end
end
