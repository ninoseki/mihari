# frozen_string_literal: true

RSpec.describe Mihari::Emitters::Slack do
  subject { described_class.new }

  let(:artifacts) {
    [
      Mihari::Artifact.new("1.1.1.1"),
      Mihari::Artifact.new("github.com"),
      Mihari::Artifact.new("http://example.com"),
      Mihari::Artifact.new("44d88612fea8a8f36de82e1278abb02f"),
      Mihari::Artifact.new("example@gmail.com")
    ]
  }

  describe "#to_attachments" do
    it do
      attachments = subject.to_attachments(artifacts)
      attachments.each do |a|
        actions = a.dig(:actions) || []
        actions.each do |action|
          expect(action.dig(:url)).to start_with("https://www.virustotal.com").or start_with("https://urlscan.io")
        end
      end
    end
  end

  describe "#valid?" do
    context "when SLAC_WEBHOOK_URL is given" do
      before do
        allow(ENV).to receive(:key?).with("SLACK_WEBHOOK_URL").and_return(true)
        allow(ENV).to receive(:fetch).with("SLACK_WEBHOOK_URL").and_return("http://example.com")
      end

      it do
        expect(subject.valid?).to be(true)
      end
    end

    context "when SLAC_WEBHOOK_URL is not given" do
      before do
        allow(ENV).to receive(:key?).with("SLACK_WEBHOOK_URL").and_return(false)
      end

      it do
        expect(subject.valid?).to be(false)
      end
    end
  end

  describe "#emit" do
    let(:title) { "test" }
    let(:description) { "test" }
    let(:mock) { double("notifier") }

    before do
      allow(Mihari::Notifiers::Slack).to receive(:new).and_return(mock)
      allow(mock).to receive(:notify)
      allow(mock).to receive(:valid?).and_return(true)
    end

    it do
      subject.emit(title: title, description: description, artifacts: artifacts)
      expect(mock).to have_received(:notify).once
    end
  end
end
