# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::ZoomEye, :vcr do
  subject { described_class.new(query) }

  let(:query) { "sagawa.apk" }

  describe "#artifacts" do
    it do
      expect(subject.artifacts).to be_an(Array)
    end
  end

  context "when given web type" do
    subject { described_class.new(query, type: type) }

    let(:query) { "wordpress +wooo +en-US" }
    let(:type) { "web" }

    describe "#artifacts" do
      it do
        expect(subject.artifacts).to be_an(Array)
      end
    end
  end

  context "when api config is not given" do
    before do
      allow(Mihari.config).to receive(:zoomeye_api_key).and_return(nil)
    end

    it do
      expect { subject.artifacts }.to raise_error(ArgumentError)
    end
  end
end
