# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Shodan, :vcr do
  subject { described_class.new(query) }

  let(:query) { "ip:1.1.1.1" }

  describe "#artifacts" do
    it do
      artifacts = subject.artifacts

      expect(artifacts).to be_an(Array)
      expect(artifacts.length).to eq(1)

      first = artifacts.first
      expect(first.data).to eq("1.1.1.1")

      expect(first.autonomous_system.asn).to eq(13_335)

      expect(first.geolocation.country_code).to eq("US")

      expect(first.metadata).to be_an(Array)
      expect(first.metadata.first).to be_a(Hash)

      expect(first.ports.length).to be > 0
      expect(first.reverse_dns_names.length).to be > 0
    end
  end

  context "without API credentials" do
    before do
      allow(Mihari.config).to receive(:shodan_api_key).and_return(nil)
    end

    it do
      expect { subject.artifacts }.to raise_error(ArgumentError)
    end
  end
end
