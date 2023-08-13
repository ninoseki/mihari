# frozen_string_literal: true

RSpec.describe Mihari::Emitters::TheHive, :vcr do
  include_context "with database fixtures"

  let(:artifacts) { [Mihari::Artifact.new(data: "1.1.1.1")] }
  let(:rule) { Mihari::Services::RuleProxy.from_model(Mihari::Rule.first) }

  subject { described_class.new(artifacts: artifacts, rule: rule) }

  describe "#valid?" do
    before do
      allow(Mihari.config).to receive(:thehive_api_version).and_return("v4")
    end

    it do
      expect(subject.valid?).to be(true)
    end

    it do
      expect(subject.normalized_api_version).to be(nil)
    end

    context "when THEHIVE_URL is not given" do
      before do
        allow(Mihari.config).to receive(:thehive_url).and_return(nil)
      end

      it do
        expect(subject.valid?).to be(false)
      end
    end

    context "when THEHIVE_API_VERSION is given" do
      before do
        allow(Mihari.config).to receive(:thehive_api_version).and_return("v5")
      end

      it do
        expect(subject.normalized_api_version).to eq("v1")
      end
    end
  end

  describe "#emit" do
    let(:mock_client) { double("client") }

    before do
      allow(subject).to receive(:client).and_return(mock_client)
      allow(mock_client).to receive(:alert)
    end

    it do
      subject.emit
      expect(mock_client).to have_received(:alert)
    end
  end
end
