# frozen_string_literal: true

RSpec.describe Mihari::Emitters::Webhook do
  include_context "with fake HTTPBin"

  let!(:url) { "#{server.base_url}/post" }

  let_it_be(:artifact) { FactoryBot.create(:artifact) }
  let_it_be(:artifacts) { [artifact] }
  let_it_be(:rule) { Mihari::Rule.from_model artifact.rule }

  describe "#configured?" do
    context "without URL" do
      let(:emitter) { described_class.new(rule: rule) }

      it do
        expect(emitter.configured?).to be false
      end
    end

    context "with URL" do
      let(:emitter) { described_class.new(rule: rule, url: url) }

      it do
        expect(emitter.configured?).to be true
      end
    end
  end

  describe "#call" do
    let(:emitter) do
      described_class.new(
        rule: rule,
        url: url,
        headers: { "Content-Type": "application/json" }
      )
    end

    it do
      res = emitter.call [artifact]
      json = JSON.parse(res)["json"]
      expect(json["rule"]["id"]).to eq(rule.id)
      expect(json["artifacts"]).to eq(artifacts.map(&:data))
      expect(json["tags"]).to eq(rule.tags.map(&:name))
    end

    context "with a template file" do
      let(:emitter) do
        described_class.new(
          rule: rule,
          url: url,
          template: "spec/fixtures/templates/test.json.jbuilder",
          headers: { "Content-Type": "application/json" }
        )
      end

      it do
        res = emitter.call [artifact]
        json = JSON.parse(res)["json"]
        expect(json["id"]).to eq(rule.id)
      end
    end
  end

  describe "#target" do
    let(:emitter) { described_class.new(rule: rule, url: url) }

    it do
      expect(emitter.target).to be_a(String)
    end
  end
end
