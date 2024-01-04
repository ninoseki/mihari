# frozen_string_literal: true

RSpec.describe Mihari::Emitters::Webhook do
  include_context "with fake HTTPBin"

  let!(:url) { "#{server.base_url}/post" }
  let!(:artifacts) do
    [
      Mihari::Models::Artifact.new(data: "1.1.1.1"),
      Mihari::Models::Artifact.new(data: "github.com")
    ]
  end

  let_it_be(:rule) { Mihari::Rule.from_model FactoryBot.create(:rule) }

  describe "#configured?" do
    context "without URL" do
      subject(:emitter) { described_class.new(rule: rule) }

      it do
        expect(emitter.configured?).to be false
      end
    end

    context "with URL" do
      subject(:emitter) { described_class.new(rule: rule, url: url) }

      it do
        expect(emitter.configured?).to be true
      end
    end
  end

  describe "#call" do
    subject(:emitter) { described_class.new(rule: rule, url: url, headers: { "Content-Type": "application/json" }) }

    it do
      res = emitter.call artifacts
      json = JSON.parse(res)["json"]
      expect(json["rule"]["id"]).to eq(rule.id)
      expect(json["artifacts"]).to eq(artifacts.map(&:data))
      expect(json["tags"]).to eq(rule.tags.map(&:name))
    end
  end
end
