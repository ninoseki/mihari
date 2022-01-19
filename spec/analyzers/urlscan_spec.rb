# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Urlscan, :vcr do
  subject { described_class.new(query) }

  let(:query) { "page.domain:example.com AND date:[2020-01-01 TO 2020-08-01]" }

  describe "#artifacts" do
    it do
      expect(subject.artifacts).to be_an(Array)
    end

    context "when given a type option" do
      subject { described_class.new(query, allowed_data_types: %w[domain]) }

      it do
        artifacts = subject.artifacts
        expect(artifacts.none? { |artifact| artifact.data.start_with?("http", "https") }).to eq(true)
      end
    end
  end

  describe "#initialize" do
    context "when given an invalid target_type" do
      it do
        expect { described_class.new(query, allowed_data_types: %w[foo bar]) }.to raise_error(Mihari::InvalidInputError)
      end
    end
  end
end
