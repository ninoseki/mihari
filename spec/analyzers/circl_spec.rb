# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::CIRCL, :vcr do
  subject(:analyzer) { described_class.new(query) }

  context "with domain" do
    let(:query) { "www.circl.lu" }

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

  context "with invalid input" do
    let(:query) { "foo bar" }

    describe "#artifacts" do
      it do
        expect { analyzer.artifacts }.to raise_error(Mihari::ValueError)
      end
    end
  end

  context "without API credentials" do
    let(:query) { "example.com" }

    before do
      allow(Mihari.config).to receive(:circl_passive_password).and_return(nil)
      allow(Mihari.config).to receive(:circl_passive_username).and_return(nil)
    end

    it do
      expect { analyzer.artifacts }.to raise_error(ArgumentError)
    end
  end
end
