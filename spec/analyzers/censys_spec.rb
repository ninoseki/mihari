# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Censys do
  subject(:analyzer) { described_class.new(query, options: options, **credentials) }

  let(:query) { "ip:1.1.1.1" }
  let(:options) { nil }
  let(:credentials) { {} }

  describe "#artifacts" do
    context "with legacy API (default)" do
      let(:client) { instance_double(Mihari::Clients::Censys) }
      let(:artifact) do
        instance_double(
          Mihari::Models::Artifact,
          data: "1.1.1.1",
          autonomous_system: instance_double(Mihari::Models::AutonomousSystem, number: 13_335),
          ports: [80]
        )
      end
      let(:result) { instance_double(Mihari::Structs::Censys::Result, artifacts: [artifact]) }
      let(:response) { instance_double(Mihari::Structs::Censys::Response, result: result) }

      before do
        allow(Mihari::Clients::Censys).to receive(:new).and_return(client)
        allow(client).to receive(:search_with_pagination).and_return([response])
      end

      it "returns search results" do
        artifacts = analyzer.artifacts

        expect(artifacts).to be_an(Array)
        expect(artifacts.length).to eq(1)

        first = artifacts.first
        expect(first.data).to eq("1.1.1.1")

        expect(first.autonomous_system.number).to eq(13_335)
        expect(first.ports.length).to be > 0
      end
    end

    context "with Platform API" do
      let(:options) { {version: 3} }
      let(:credentials) { {api_key: "token"} }
      let(:client) { instance_double(Mihari::Clients::CensysV3) }
      let(:artifact) { instance_double(Mihari::Models::Artifact, data: "1.1.1.1") }
      let(:response) { instance_double(Mihari::Structs::CensysV3::Response, artifacts: [artifact]) }

      before do
        allow(Mihari::Clients::CensysV3).to receive(:new).and_return(client)
        allow(client).to receive(:search_with_pagination).and_return([response])
      end

      it "returns artifacts from the platform client" do
        expect(analyzer.artifacts).to eq([artifact])
      end
    end

    context "when version is omitted" do
      let(:client) { instance_double(Mihari::Clients::Censys) }
      let(:artifact) { instance_double(Mihari::Models::Artifact, data: "1.1.1.1") }
      let(:result) { instance_double(Mihari::Structs::Censys::Result, artifacts: [artifact]) }
      let(:response) { instance_double(Mihari::Structs::Censys::Response, result: result) }

      before do
        allow(Mihari::Clients::Censys).to receive(:new).and_return(client)
        allow(client).to receive(:search_with_pagination).and_return([response])
        allow(Mihari.logger).to receive(:warn)
      end

      it "logs a single deprecation warning" do
        analyzer.artifacts
        expect(Mihari.logger).to have_received(:warn).once
      end
    end
  end

  context "without API credentials" do
    before do
      allow(Mihari.config).to receive(:censys_id).and_return(nil)
      allow(Mihari.config).to receive(:censys_secret).and_return(nil)
    end

    it "raises an error" do
      expect { analyzer.artifacts }.to raise_error(ArgumentError)
    end
  end
end
