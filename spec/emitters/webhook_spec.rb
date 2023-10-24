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
  let!(:rule) { Mihari::Services::RuleProxy.from_model(Mihari::Models::Rule.first) }

  describe "#valid?" do
    context "without URL" do
      subject do
        described_class.new(
          artifacts: artifacts, rule: rule
        )
      end

      it do
        expect(subject.valid?).to be false
      end
    end

    context "with URL" do
      subject do
        described_class.new(
          artifacts: artifacts, rule: rule, url: "http://example.com"
        )
      end

      it do
        expect(subject.valid?).to be true
      end
    end
  end

  describe "#emit" do
    subject do
      described_class.new(
        artifacts: artifacts,
        rule: rule,
        url: url,
        headers: { "Content-Type": "application/json" }
      )
    end

    let!(:url) { "https://httpbin.org/post" }

    it do
      res = subject.emit
      json_data = JSON.parse(res)["json"]
      expect(json_data).to be_a(Hash)
    end
  end
end
