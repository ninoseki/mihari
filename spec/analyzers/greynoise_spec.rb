# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::GreyNoise, :vcr do
  let(:query) { "cve:CVE-2020-9054" }

  subject { described_class.new(query) }

  describe "#title" do
    it do
      expect(subject.title).to eq("GreyNoise search")
    end
  end

  describe "#description" do
    it do
      expect(subject.description).to eq("query = #{query}")
    end
  end

  describe "#artifacts" do
    it do
      artifacts = subject.artifacts
      expect(artifacts).to be_an(Array)
    end
  end
end
