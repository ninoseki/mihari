# frozen_string_literal: true

require "json"

RSpec.describe Mihari::Emitters::Webhook, :vcr do
  include_context "with database fixtures"

  let!(:artifacts) do
    [
      Mihari::Models::Artifact.new(data: "1.1.1.1"),
      Mihari::Models::Artifact.new(data: "github.com")
    ]
  end
  let!(:rule) { Mihari::Rule.from_model(Mihari::Models::Rule.first) }

  describe "#configured?" do
    context "without URL" do
      subject(:emitter) { described_class.new(rule: rule) }

      it do
        expect(emitter.configured?).to be false
      end
    end

    context "with URL" do
      subject(:emitter) { described_class.new(rule: rule, url: "http://example.com") }

      it do
        expect(emitter.configured?).to be true
      end
    end
  end

  describe "#emit" do
    subject(:emitter) { described_class.new(rule: rule, url: url, headers: { "Content-Type": "application/json" }) }

    let!(:url) { "https://httpbin.org/post" }

    it do
      res = emitter.emit artifacts
      json_data = JSON.parse(res)["json"]
      expect(json_data).to be_a(Hash)
    end
  end
end
