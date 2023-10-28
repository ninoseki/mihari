# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::BinaryEdge, :vcr do
  subject(:analyzer) { described_class.new(query) }

  let!(:query) { "sagawa.apk" }

  describe "#artifacts" do
    it do
      expect(analyzer.artifacts).to be_an(Array)
    end
  end
end
