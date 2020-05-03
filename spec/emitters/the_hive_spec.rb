# frozen_string_literal: true

RSpec.describe Mihari::Emitters::TheHive, :vcr do
  subject { described_class.new }

  describe "#valid?" do
    it do
      expect(subject.valid?).to be(true)
    end

    context "when THEHIVE_API_ENDPOINT is not given" do
      before do
        allow(Mihari.config).to receive(:thehive_api_endpoint).and_return(nil)
      end

      it do
        expect(subject.valid?).to be(false)
      end
    end
  end

  describe "#emit" do
    let(:title) { "test" }
    let(:description) { "test" }
    let(:artifacts) { [Mihari::Artifact.new(data: "1.1.1.1")] }

    let(:mock_thehive) { double("thehive") }
    let(:mock_alert) { double("alert") }

    before do
      allow(subject).to receive(:api).and_return(mock_thehive)
      allow(mock_thehive).to receive(:alert).and_return(mock_alert)
      allow(mock_alert).to receive(:create)
    end

    it do
      subject.emit(title: title, description: description, artifacts: artifacts)
      expect(mock_alert).to have_received(:create)
    end
  end
end
