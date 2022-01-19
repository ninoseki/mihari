# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::PassiveTotal, :vcr do
  subject { described_class.new(query) }

  context "when given an ipv4" do
    let(:query) { "89.35.39.84" }

    describe "#artifacts" do
      it do
        expect(subject.artifacts).to be_an(Array)
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

  context "when given a hash" do
    let(:query) { "7c552ab044c76d1df4f5ddf358807bfdcd07fa57" }

    describe "#artifacts" do
      it do
        expect(subject.artifacts).to be_an(Array)
      end
    end
  end

  context "when given an email" do
    let(:query) { "test@test.com" }

    describe "#artifacts" do
      it do
        expect(subject.artifacts).to be_an(Array)
      end
    end
  end

  context "when given an invalid input" do
    let(:query) { "foo bar" }

    describe "#artifacts" do
      it do
        expect { subject.artifacts }.to raise_error(Mihari::InvalidInputError)
      end
    end
  end

  context "when api config is not given" do
    let(:query) { "89.35.39.84" }

    before do
      allow(Mihari.config).to receive(:passivetotal_api_key).and_return(nil)
      allow(Mihari.config).to receive(:passivetotal_username).and_return(nil)
    end

    it do
      expect { subject.artifacts }.to raise_error(ArgumentError)
    end
  end
end
