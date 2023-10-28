# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::ZoomEye, :vcr do
  subject { described_class.new(query, type: type) }

  let(:type) { "host" }

  describe "#artifacts" do
    let(:query) { "sagawa.apk" }

    it do
      expect(subject.artifacts).to be_an(Array)
    end
  end

  context "with web type" do
    let(:query) { "wordpress +wooo +en-US" }
    let(:type) { "web" }

    describe "#artifacts" do
      it do
        expect(subject.artifacts).to be_an(Array)
      end
    end
  end

  context "without API credentials" do
    let(:query) { "dummy" }

    before do
      allow(Mihari.config).to receive(:zoomeye_api_key).and_return(nil)
    end

    it do
      expect { subject.artifacts }.to raise_error(ArgumentError)
    end
  end
end
