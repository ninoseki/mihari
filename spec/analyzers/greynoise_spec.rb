# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::GreyNoise, :vcr do
  subject { described_class.new(query) }

  let!(:query) { "cve:CVE-2020-9054" }

  describe "#artifacts" do
    it do
      artifacts = subject.artifacts
      expect(artifacts).to be_an(Array)
    end
  end
end
