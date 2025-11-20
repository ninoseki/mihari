# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::CensysV2, :vcr do
  subject(:analyzer) { described_class.new(query, api_key: api_key, organization_id: organization_id) }

  let(:query) { "ip:1.1.1.1" }
  let(:api_key) { ENV["CENSYS_V2_API_KEY"] }
  let(:organization_id) { ENV["CENSYS_V2_ORG_ID"] }

  describe "#artifacts" do
    it "returns an array of artifacts" do
      artifacts = analyzer.artifacts
      expect(artifacts).to be_an(Array)
      expect(artifacts.first.data).to eq("1.1.1.1")
    end
  end

  context "without API key" do
    let(:api_key) { nil }
    it "raises an ArgumentError" do
      expect { analyzer.artifacts }.to raise_error(ArgumentError)
    end
  end
end