# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::GreyNoise, :vcr do
  let(:query) { "cve:CVE-2020-9054" }

  subject { described_class.new(query) }

  describe "#artifacts" do
    it do
      artifacts = subject.artifacts
      expect(artifacts).to be_an(Array)
    end
  end
end
