# frozen_string_literal: true

RSpec.describe Mihari::Emitters::Slack do
  include_context "with database fixtures"

  let(:rule) { Mihari::Services::RuleProxy.from_model(Mihari::Rule.first) }
  let(:artifacts) do
    [
      Mihari::Artifact.new(data: "1.1.1.1"),
      Mihari::Artifact.new(data: "github.com"),
      Mihari::Artifact.new(data: "http://example.com"),
      Mihari::Artifact.new(data: "44d88612fea8a8f36de82e1278abb02f"),
      Mihari::Artifact.new(data: "example@gmail.com")
    ]
  end

  subject { described_class.new(artifacts: artifacts, rule: rule) }

  describe "#attachments" do
    it do
      subject.attachments.each do |a|
        actions = a[:actions] || []
        actions.each do |action|
          expect(action[:url]).to match(/virustotal|urlscan|censys|shodan/)
        end
      end
    end
  end

  describe "#text" do
    context "when not given tags" do
      it do
        expect(subject.text).to eq("*test1*\n*Desc.*: test1\n*Tags*: tag1")
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
    let(:mock) { double("notifier") }

    before do
      allow(::Slack::Notifier).to receive(:new).and_return(mock)
      allow(mock).to receive(:post)
    end

    it do
      subject.emit
      expect(mock).to have_received(:post).once
    end
  end
end
