# frozen_string_literal: true

require "json"

RSpec.describe Mihari::Emitters::HTTP, :vcr do
  include_context "with database fixtures"

  describe "#valid?" do
    context "without uri" do
      it do
        emitter = described_class.new
        expect(emitter.valid?).to eq(false)
      end
    end

    context "with uri" do
      it do
        emitter = described_class.new(uri: "http://example.com")
        expect(emitter.valid?).to eq(true)
      end
    end
  end

  describe "#emit" do
    let(:artifacts) do
      [
        Mihari::Artifact.new(data: "1.1.1.1"),
        Mihari::Artifact.new(data: "github.com")
      ]
    end
    let(:rule) { Mihari::Rule.first }
    let(:tags) { [] }
    let(:uri) { "https://httpbin.org/post" }

    it do
      emitter = described_class.new(uri: uri, http_request_headers: { "Content-Type": "application/json" })
      res = emitter.emit(artifacts: artifacts, rule: rule, tags: tags)

      json_data = JSON.parse(res.body.to_s)["json"]
      expect(json_data).to be_a(Hash)
    end
  end
end
