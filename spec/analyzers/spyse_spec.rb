# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Spyse, :vcr do
  context "when given an ipv4" do
    subject { described_class.new(query, type: "ip") }

    let(:query) {
      JSON.generate([{ ptr: { operator: "eq", value: "example.com" } }])
    }

    describe "#artifacts" do
      it do
        artifacts = subject.artifacts
        expect(artifacts).to be_an(Array)
      end
    end
  end

  context "when given a domain" do
    subject { described_class.new(query, type: "domain") }

    let(:query) { JSON.generate([dns_a: { operator: "eq", value: "8.8.8.8" }]) }

    describe "#artifacts" do
      it do
        artifacts = subject.artifacts
        expect(artifacts).to be_an(Array)
      end
    end
  end

  context "when given an invalid input" do
    subject { described_class.new(query, type: "foo") }

    let(:query) { "foo bar" }

    describe "#artifacts" do
      it do
        expect { subject.artifacts }.to raise_error(Mihari::InvalidInputError)
      end
    end
  end

  context "when api config is not given" do
    before do
      allow(Mihari.config).to receive(:spyse_api_key).and_return(nil)
    end

    it do
      expect { subject.artifacts }.to raise_error(ArgumentError)
    end
  end
end
