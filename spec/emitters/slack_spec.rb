# frozen_string_literal: true

RSpec.describe Mihari::Emitters::Slack do
  subject(:emitter) { described_class.new(rule: rule) }

  let_it_be(:rule) { Mihari::Rule.from_model FactoryBot.create(:rule) }
  let!(:artifacts) do
    [
      Mihari::Models::Artifact.new(data: "1.1.1.1"),
      Mihari::Models::Artifact.new(data: "github.com"),
      Mihari::Models::Artifact.new(data: "http://example.com"),
      Mihari::Models::Artifact.new(data: "44d88612fea8a8f36de82e1278abb02f"),
      Mihari::Models::Artifact.new(data: "example@gmail.com")
    ]
  end

  describe "#attachments" do
    before { emitter.artifacts = artifacts }

    it do
      expect(emitter.attachments.length).to be > 0
    end

    it do
      emitter.attachments.each do |attachment|
        urls = (attachment[:actions] || []).map { |action| action[:url] }
        expect(urls).to all(match(/virustotal|urlscan|censys|shodan/))
      end
    end
  end

  describe "#text" do
    let!(:tags) { rule.tags.map(&:name).join(", ") }

    it do
      expect(emitter.text).to include("*Desc.*: #{rule.description}\n*Tags*: #{tags}")
    end
  end

  describe "#configured?" do
    context "with SLACK_WEBHOOK_URL" do
      before do
        allow(Mihari.config).to receive(:slack_webhook_url).and_return("http://example.com")
      end

      it do
        expect(emitter.configured?).to be(true)
      end
    end

    context "without SLACK_WEBHOOK_URL" do
      before do
        allow(Mihari.config).to receive(:slack_webhook_url).and_return(nil)
      end

      it do
        expect(emitter.configured?).to be(false)
      end
    end
  end

  describe "#call" do
    let!(:mock) { instance_double("notifier") }

    before do
      allow(::Slack::Notifier).to receive(:new).and_return(mock)
      allow(mock).to receive(:post)
    end

    it do
      emitter.call artifacts
      expect(mock).to have_received(:post).once
    end
  end
end
