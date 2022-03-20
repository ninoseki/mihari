# frozen_string_literal: true

RSpec.describe Mihari::Emitters::Webhook, :vcr do
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
    let(:title) { "title" }
    let(:description) { "description" }
    let(:artifacts) {
      [
        Mihari::Artifact.new(data: "1.1.1.1"),
        Mihari::Artifact.new(data: "github.com")
      ]
    }
    let(:source) { "test" }
    let(:tags) { [] }

    before do
      allow(Mihari.config).to receive(:webhook_url).and_return("https://httpbin.org/post")
      allow(Mihari.config).to receive(:webhook_use_json_body).and_return("true")
    end

    it do
      subject.emit(title: title, description: description, artifacts: artifacts, source: source, tags: tags)
    end
  end
end
