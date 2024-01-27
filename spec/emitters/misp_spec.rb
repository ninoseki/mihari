# frozen_string_literal: true

RSpec.describe Mihari::Emitters::MISP, :vcr do
  subject(:emitter) { described_class.new(rule:) }

  include_context "with mocked logger"

  let_it_be(:rule) { Mihari::Rule.from_model FactoryBot.create(:rule) }
  let!(:artifacts) { [Mihari::Models::Artifact.new(data: "1.1.1.1")] }

  describe "#configured?" do
    context "when MISP_URL & MISP_API_KEY are not given" do
      before do
        allow(Mihari.config).to receive(:misp_url).and_return(nil)
        allow(Mihari.config).to receive(:misp_api_key).and_return(nil)
      end

      it do
        expect(emitter.configured?).to be(false)
      end
    end
  end

  describe "#call" do
    it do
      emitter.call artifacts
    end
  end

  describe "#target" do
    it do
      expect(emitter.target).to be_a(String)
    end
  end
end
