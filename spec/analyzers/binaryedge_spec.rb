# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::BinaryEdge, :vcr do
  subject { described_class.new(query) }

  let(:query) { "sagawa.apk" }

  describe "#artifacts" do
    it do
      expect(subject.artifacts).to be_an(Array)
    end
  end
end
