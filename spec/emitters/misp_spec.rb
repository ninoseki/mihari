# frozen_string_literal: true

RSpec.describe Mihari::Emitters::MISP, :vcr do
  subject { described_class.new }

  describe "#valid?" do
    context "when MISP_API_ENDPOINT & MISP_API_KEY are not given" do
      let(:mock_configuration) { double("configuration") }

      before do
        allow(MISP).to receive(:configuration).and_return(mock_configuration)

        allow(mock_configuration).to receive(:api_endpoint).and_return(nil)
        allow(mock_configuration).to receive(:api_key).and_return(nil)
      end

      it do
        expect(subject.valid?).to be(false)
      end
    end
  end

  describe "#emit" do
    let(:title) { "test" }
    let(:description) { "test" }
    let(:artifacts) { [Mihari::Artifact.new("1.1.1.1")] }
    let(:tags) { %w(test) }

    it do
      event = subject.emit(title: title, description: description, artifacts: artifacts, tags: tags)
      expect(event).to be_a(MISP::Event)
    end
  end
end
