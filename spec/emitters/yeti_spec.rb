# frozen_string_literal: true

RSpec.describe Mihari::Emitters::Yeti do
  subject(:emitter) { described_class.new(rule:) }

  include_context "with mocked logger"

  let_it_be(:rule) { Mihari::Rule.from_model FactoryBot.create(:rule) }
  let!(:artifacts) { [Mihari::Models::Artifact.new(data: "1.1.1.1")] }

  describe "#configured?" do
    it do
      expect(emitter.configured?).to be(true)
    end

    context "without YETI_URL" do
      before do
        allow(Mihari.config).to receive(:yeti_url).and_return(nil)
      end

      it do
        expect(emitter.configured?).to be(false)
      end
    end
  end

  describe "#call" do
    let!(:mock_client) { instance_double(Mihari::Clients::Yeti) }
    let!(:mocked_emitter) { described_class.new(rule:) }

    before do
      allow(mocked_emitter).to receive(:client).and_return(mock_client)
      allow(mock_client).to receive(:create_observables)
    end

    it do
      mocked_emitter.call artifacts
      expect(mock_client).to have_received(:create_observables)
    end
  end

  describe "#target" do
    it do
      expect(emitter.target).to be_a(String)
    end
  end
end
