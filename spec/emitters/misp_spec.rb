# frozen_string_literal: true

RSpec.describe Mihari::Emitters::MISP, :vcr do
  include_context "with database fixtures"

  subject { described_class.new }

  describe "#valid?" do
    context "when MISP_URL & MISP_API_KEY are not given" do
      before do
        allow(Mihari.config).to receive(:misp_url).and_return(nil)
        allow(Mihari.config).to receive(:misp_api_key).and_return(nil)
      end

      it do
        expect(subject.valid?).to be(false)
      end
    end
  end

  describe "#emit" do
    let(:artifacts) { [Mihari::Artifact.new(data: "1.1.1.1")] }
    let(:rule) { Mihari::Structs::Rule.from_model(Mihari::Rule.first) }

    it do
      event = subject.emit(artifacts: artifacts, rule: rule)
      expect(event).to be_a(MISP::Event)
    end
  end
end
