# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::OTX, :vcr do
  context "with ip" do
    subject { described_class.new(query) }

    let(:query) { "89.35.39.84" }

    describe "#artifacts" do
      it do
        expect(subject.artifacts).to be_an(Array)
      end
    end
  end

  context "with domain" do
    subject { described_class.new(query) }

    let(:query) { "jppost-tu.top" }

    describe "#artifacts" do
      it do
        expect(subject.artifacts).to be_an(Array)
      end
    end
  end

  context "with invalid input" do
    subject { described_class.new(query) }

    let(:query) { "foo bar" }

    describe "#artifacts" do
      it do
        expect { subject.artifacts }.to raise_error(Mihari::ValueError)
      end
    end
  end

  context "without API credentials" do
    before do
      allow(Mihari.config).to receive(:otx_api_key).and_return(nil)
    end

    it do
      expect { subject.artifacts }.to raise_error(ArgumentError)
    end
  end
end
