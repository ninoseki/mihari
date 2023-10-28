# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::PassiveTotal, :vcr do
  subject(:analyzer) { described_class.new(query) }

  context "with ip" do
    let(:query) { "89.35.39.84" }

    describe "#artifacts" do
      it do
        expect(analyzer.artifacts).to be_an(Array)
      end
    end
  end

  context "with domain" do
    let(:query) { "jppost-tu.top" }

    describe "#artifacts" do
      it do
        expect(analyzer.artifacts).to be_an(Array)
      end
    end
  end

  context "with hash" do
    let(:query) { "7c552ab044c76d1df4f5ddf358807bfdcd07fa57" }

    describe "#artifacts" do
      it do
        expect(analyzer.artifacts).to be_an(Array)
      end
    end
  end

  context "with email" do
    let(:query) { "test@test.com" }

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
    let(:query) { "89.35.39.84" }

    before do
      allow(Mihari.config).to receive(:passivetotal_api_key).and_return(nil)
      allow(Mihari.config).to receive(:passivetotal_username).and_return(nil)
    end

    it do
      expect { analyzer.artifacts }.to raise_error(ArgumentError)
    end
  end
end
