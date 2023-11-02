# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Fofa, :vcr do
  subject(:analyzer) { described_class.new(query) }

  let!(:query) { 'ip="1.0.0.1"' }

  describe "#artifacts" do
    it do
      expect(analyzer.artifacts).to be_an(Array)
    end
  end
end
