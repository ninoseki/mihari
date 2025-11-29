# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Censys, :vcr do
  context "v2" do
    subject(:analyzer) { described_class.new(query, version: 2) }

    let(:query) { "ip:1.1.1.1" }

    describe "#artifacts" do
      it do
        artifacts = analyzer.artifacts

        expect(artifacts).to be_an(Array)
        expect(artifacts.length).to eq(1)

        first = artifacts.first
        expect(first.data).to eq("1.1.1.1")

        expect(first.autonomous_system.number).to eq(13_335)
        expect(first.ports.length).to be > 0
      end
    end

    context "without API credentials" do
      before do
        allow(Mihari.config).to receive(:censys_id).and_return(nil)
        allow(Mihari.config).to receive(:censys_secret).and_return(nil)
      end

      it do
        expect { analyzer.artifacts }.to raise_error(ArgumentError)
      end
    end
  end

  context "v3" do
    subject(:analyzer) { described_class.new(query, version: 3) }

    let(:query) { "host.ip:1.1.1.1" }

    describe "#artifacts" do
      it "returns artifacts from the platform client" do
        expect(analyzer.artifacts).to eq([artifact])
      end
    end

    context "without API credentials" do
      before do
        allow(Mihari.config).to receive(:censys_api_key).and_return(nil)
        allow(Mihari.config).to receive(:censys_organization_id).and_return(nil)
      end

      it do
        expect { analyzer.artifacts }.to raise_error(ArgumentError)
      end
    end
  end
end
