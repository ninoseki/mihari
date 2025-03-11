# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::ZoomEye, :vcr do
  subject(:analyzer) { described_class.new(query) }

  let(:query) { 'ip="8.8.8.8" && hostname="dns.google"' }

  describe "#artifacts" do
    it do
      expect(analyzer.artifacts).to be_an(Array)
    end
  end

  context "without API credentials" do
    let(:query) { "dummy" }

    before do
      allow(Mihari.config).to receive(:zoomeye_api_key).and_return(nil)
    end

    it do
      expect { analyzer.artifacts }.to raise_error(ArgumentError)
    end
  end
end
