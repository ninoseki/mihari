# frozen_string_literal: true

RSpec.describe Mihari::Emitters::Webhook, :vcr do
  include_context "with database fixtures"

  subject { described_class.new }

  describe "#valid?" do
    it do
      expect(subject.valid?).to be(true)
    end

    context "when WEBHOOK_URL is not given" do
      before do
        allow(Mihari.config).to receive(:webhook_url).and_return(nil)
      end

      it do
        expect(subject.valid?).to be(false)
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

    before do
      allow(Mihari.config).to receive(:webhook_url).and_return("https://httpbin.org/post")
      allow(Mihari.config).to receive(:webhook_use_json_body).and_return("true")
    end

    it do
      subject.emit(artifacts: artifacts, rule: rule, tags: tags)
    end
  end
end
