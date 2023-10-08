# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Onyphe, :vcr do
  subject { described_class.new(query) }

  let!(:query) { "4299114377898569169" }

  describe "#artifacts" do
    it do
      artifacts = subject.artifacts
      expect(artifacts).to be_an(Array)

      expect(artifacts.first.autonomous_system.asn).to eq(3462)
      expect(artifacts.first.geolocation.country).to eq("Taiwan")
    end
  end

  context "without API credentials" do
    before do
      allow(Mihari.config).to receive(:onyphe_api_key).and_return(nil)
    end

    it do
      expect { subject.artifacts }.to raise_error(ArgumentError)
    end
  end
end
