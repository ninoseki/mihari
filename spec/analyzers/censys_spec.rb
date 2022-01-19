# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Censys, :vcr do
  subject { described_class.new(query) }

  let(:query) { "ip:1.1.1.1" }

  describe "#artifacts" do
    it do
      artifacts = subject.artifacts

      expect(artifacts).to be_an(Array)
      expect(artifacts.length).to eq(1)

      expect(artifacts.first.data).to eq("1.1.1.1")

      expect(artifacts.first.autonomous_system.asn).to eq(13_335)

      expect(artifacts.first.geolocation.country_code).to eq("AU")
    end
  end

  context "when api config is not given" do
    before do
      allow(Mihari.config).to receive(:censys_id).and_return(nil)
      allow(Mihari.config).to receive(:censys_secret).and_return(nil)
    end

    it do
      expect { subject.artifacts }.to raise_error(ArgumentError)
    end
  end
end
