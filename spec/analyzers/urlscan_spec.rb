# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Urlscan, :vcr do
  subject(:analyzer) { described_class.new(query) }

  let!(:query) { "page.domain:example.com AND date:[2023-01-01 TO 2023-02-01]" }

  describe "#artifacts" do
    it do
      expect(analyzer.artifacts).to be_an(Array)
    end

    context "with allowed data types" do
      subject(:analyzer) { described_class.new(query, allowed_data_types: %w[domain]) }

      it do
        artifacts = analyzer.artifacts
        expect(artifacts.none? { |artifact| artifact.data.start_with?("http", "https") }).to be true
      end
    end
  end

  describe "#initialize" do
    context "with invalid allowed data types" do
      it do
        expect { described_class.new(query, allowed_data_types: %w[foo bar]) }.to raise_error(Mihari::ValueError)
      end
    end
  end
end
