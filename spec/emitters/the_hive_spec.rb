# frozen_string_literal: true

RSpec.describe Mihari::Emitters::TheHive, :vcr do
  subject { described_class.new }

  describe "#valid?" do
    context "when SLAC_WEBHOOK_URL is given" do
      before do
        allow(ENV).to receive(:key?).with("THEHIVE_API_ENDPOINT").and_return(true)
        allow(ENV).to receive(:key?).with("THEHIVE_API_KEY").and_return(true)
      end

      it do
        expect(subject.valid?).to be(true)
      end
    end

    context "when THEHIVE_API_ENDPOINT is not given" do
      before do
        allow(ENV).to receive(:key?).with("THEHIVE_API_ENDPOINT").and_return(false)
      end

      it do
        expect(subject.valid?).to be(false)
      end
    end
  end

  describe "#emit" do
    let(:title) { "test" }
    let(:description) { "test" }
    let(:artifacts) { [Mihari::Artifact.new("1.1.1.1")] }

    let(:mock_thehie) { double("thehive") }
    let(:mock_alert) { double("alert") }

    before do
      allow(subject).to receive(:the_hive).and_return(mock_thehie)
      allow(mock_thehie).to receive(:alert).and_return(mock_alert)
      allow(mock_alert).to receive(:create)

      FakeFS.activate!
    end

    after do
      FakeFS.deactivate!
    end

    it do
      subject.emit(title: title, description: description, artifacts: artifacts)
      expect(mock_alert).to have_received(:create)
    end
  end
end
