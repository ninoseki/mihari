# frozen_string_literal: true

RSpec.describe Mihari::Notifiers::Slack do
  subject { described_class.new }

  describe "#to_attachments" do
    let(:artifacts) {
      [
        Mihari::Artifact.new("1.1.1.1"),
        Mihari::Artifact.new("github.com"),
        Mihari::Artifact.new("http://example.com"),
        Mihari::Artifact.new("44d88612fea8a8f36de82e1278abb02f"),
        Mihari::Artifact.new("example@gmail.com")
      ]
    }

    it do
      attachments = subject.to_attachments(artifacts)
      attachments.each do |a|
        expect(a.dig(:title_link)).to start_with("https://www.virustotal.com")
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
end
