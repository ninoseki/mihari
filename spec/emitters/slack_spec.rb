# frozen_string_literal: true

RSpec.describe Mihari::Emitters::Slack do
  subject { described_class.new }

  let(:artifacts) {
    [
      Mihari::Artifact.new(data: "1.1.1.1"),
      Mihari::Artifact.new(data: "github.com"),
      Mihari::Artifact.new(data: "http://example.com"),
      Mihari::Artifact.new(data: "44d88612fea8a8f36de82e1278abb02f"),
      Mihari::Artifact.new(data: "example@gmail.com")
    ]
  }

  describe "#to_attachments" do
    it do
      attachments = subject.to_attachments(artifacts)
      attachments.each do |a|
        actions = a.dig(:actions) || []
        actions.each do |action|
          expect(action.dig(:url)).to match /virustotal|urlscan|censys/
        end
      end
    end
  end

  describe "#to_text" do
    let(:title) { "test" }
    let(:description) { "test" }

    context "when not given tags" do
      it do
        text = subject.to_text(title: title, description: description)
        expect(text).to eq("*test*\n*Desc.*: test\n*Tags*: N/A")
      end
    end

    context "when given tags" do
      let(:tags) { %w(foo bar) }

      it do
        text = subject.to_text(title: title, description: description, tags: tags)
        expect(text).to eq("*test*\n*Desc.*: test\n*Tags*: foo, bar")
      end
    end
  end

  describe "#valid?" do
    context "when SLAC_WEBHOOK_URL is given" do
      before do
        allow(Mihari.config).to receive(:slack_webhook_url).and_return("http://example.com")
      end

      it do
        expect(subject.valid?).to be(true)
      end
    end

    context "when SLAC_WEBHOOK_URL is not given" do
      before do
        allow(Mihari.config).to receive(:slack_webhook_url).and_return(nil)
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
