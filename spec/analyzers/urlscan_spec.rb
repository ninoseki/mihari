# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Urlscan, :vcr do
  subject { described_class.new(query, tags: tags) }

  let(:query) { "page.domain:example.com AND date:[2020-01-01 TO 2020-08-01]" }
  let(:tags) { %w[test] }

  describe "#title" do
    it do
      expect(subject.title).to eq("urlscan search")
    end
  end

  describe "#description" do
    it do
      expect(subject.description).to eq("query = #{query}")
    end
  end

  describe "#artifacts" do
    it do
      expect(subject.artifacts).to be_an(Array)
    end

    context "when given a type option" do
      subject { described_class.new(query, tags: tags, allowed_data_types: %w[domain]) }

      it do
        artifacts = subject.artifacts
        expect(artifacts.none? { |artifact| artifact.start_with?("http", "https") }).to eq(true)
      end
    end
  end

  describe "#tags" do
    it do
      expect(subject.tags).to eq(tags)
    end
  end

  describe "#initialize" do
    context "when given an invalid target_type" do
      it do
        expect { described_class.new(query, tags: tags, allowed_data_types: %w[foo bar]) }.to raise_error(Mihari::InvalidInputError)
      end
    end
  end
end
