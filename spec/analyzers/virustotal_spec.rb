# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::VirusTotal, :vcr do
  subject(:analyzer) { described_class.new(query) }

  context "with ipv4" do
    let(:query) { "45.83.140.140" }

    describe "#artifacts" do
      it do
        expect(analyzer.artifacts).to be_an(Array)
      end
    end
  end

  context "with domain" do
    let(:query) { "jppost-ge.top" }

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
      allow(Mihari.config).to receive(:virustotal_api_key).and_return(nil)
    end

    it do
      expect { analyzer.artifacts }.to raise_error(ArgumentError)
    end
  end
end
