# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::VirusTotalIntelligence, :vcr do
  subject { described_class.new(query) }

  context "file" do
    let(:query) { 'size:1KB- ls:"2021-09-18T00:00:00"' }

    describe "#artifacts" do
      it do
        artifacts = subject.artifacts
        expect(artifacts.all? { |artifact| artifact.data_type == "hash" }).to eq(true)
      end
    end
  end

  context "url" do
    let(:query) { 'entity:url ls:"2022-05-18T11:00:00+" url:example' }

    describe "#artifacts" do
      it do
        artifacts = subject.artifacts
        expect(artifacts.length).to be > 0
        expect(artifacts.all? { |artifact| artifact.data_type == "url" }).to eq(true)
      end
    end
  end

  context "domain" do
    let(:query) { "entity:domain domain:ninoseki" }

    describe "#artifacts" do
      it do
        artifacts = subject.artifacts
        expect(artifacts.length).to be > 0
        expect(artifacts.all? { |artifact| artifact.data_type == "domain" }).to eq(true)
      end
    end
  end

  context "ip" do
    let(:query) { "entity:ip ip:167.179.69.149" }

    describe "#artifacts" do
      it do
        artifacts = subject.artifacts
        expect(artifacts.length).to be > 0
        expect(artifacts.all? { |artifact| artifact.data_type == "ip" }).to eq(true)
      end
    end
  end
end
