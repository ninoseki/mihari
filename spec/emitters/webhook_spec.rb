# frozen_string_literal: true

require "json"

RSpec.describe Mihari::Emitters::Webhook, :vcr do
  include_context "with database fixtures"

  let(:artifacts) do
    [
      Mihari::Artifact.new(data: "1.1.1.1"),
      Mihari::Artifact.new(data: "github.com")
    ]
  end
  let(:rule) { Mihari::Services::Rule.from_model(Mihari::Rule.first) }

  describe "#valid?" do
    context "without url" do
      subject do
        described_class.new(
          artifacts: artifacts, rule: rule
        )
      end

      it do
        expect(subject.valid?).to be false
      end
    end

    context "with uri" do
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
    let(:url) { "https://httpbin.org/post" }

    subject do
      described_class.new(
        artifacts: artifacts,
        rule: rule,
        url: url,
        headers: { "Content-Type": "application/json" }
      )
    end

    it do
      res = subject.emit

      json_data = JSON.parse(res.body.to_s)["json"]
      expect(json_data).to be_a(Hash)
    end
  end
end
