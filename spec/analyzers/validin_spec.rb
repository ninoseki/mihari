# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Validin, :vcr do
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
    let(:query) { "example.com" }

    describe "#artifacts" do
      it do
        expect(analyzer.artifacts).to be_an(Array)
      end
    end
  end
end
