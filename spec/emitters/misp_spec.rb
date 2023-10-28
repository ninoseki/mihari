# frozen_string_literal: true

RSpec.describe Mihari::Emitters::MISP, :vcr do
  subject { described_class.new(rule: rule) }

  include_context "with database fixtures"
  include_context "with mocked logger"

  let!(:artifacts) { [Mihari::Models::Artifact.new(data: "1.1.1.1")] }
  let!(:rule) { Mihari::Rule.from_model(Mihari::Models::Rule.first) }

  describe "#configured?" do
    context "when MISP_URL & MISP_API_KEY are not given" do
      before do
        allow(Mihari.config).to receive(:misp_url).and_return(nil)
        allow(Mihari.config).to receive(:misp_api_key).and_return(nil)
      end

      it do
        expect(subject.configured?).to be(false)
      end
    end
  end

  describe "#emit" do
    it do
      subject.emit artifacts
    end
  end
end
