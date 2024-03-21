# frozen_string_literal: true

RSpec.describe Mihari::Emitters::TheHive do
  subject(:emitter) { described_class.new(rule:) }

  include_context "with mocked logger"

  let_it_be(:rule) { Mihari::Rule.from_model FactoryBot.create(:rule) }
  let!(:artifacts) { [Mihari::Models::Artifact.new(data: "1.1.1.1")] }

  describe "#configured?" do
    before do
      allow(Mihari.config).to receive(:thehive_api_version).and_return("v4")
    end

    it do
      expect(emitter.configured?).to be(true)
    end

    context "without THEHIVE_URL" do
      before do
        allow(Mihari.config).to receive(:thehive_url).and_return(nil)
      end

      it do
        expect(emitter.configured?).to be(false)
      end
    end
  end

  describe "#call" do
    let!(:mock_client) { instance_double("client") }
    let!(:mocked_emitter) { described_class.new(rule:) }

    before do
      allow(mocked_emitter).to receive(:client).and_return(mock_client)
      allow(mock_client).to receive(:alert)
    end

    it do
      mocked_emitter.call artifacts
      expect(mock_client).to have_received(:alert)
    end
  end

  describe "#target" do
    it do
      expect(emitter.target).to be_a(String)
    end
  end
end
