# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::ZoomEye, :vcr do
  subject { described_class.new(query, tags: tags) }

  let(:query) { "sagawa.apk" }
  let(:tags) { %w(test) }

  describe "#title" do
    it do
      expect(subject.title).to eq("ZoomEye lookup")
    end
  end

  describe "#description" do
    it do
      expect(subject.description).to eq("query = #{query}")
    end
  end

  describe "#artifacts" do
    it do
      expect(subject.artifacts).to be_an(Array)
    end
  end

  describe "#tags" do
    it do
      expect(subject.tags).to eq(tags)
    end
  end

  context "when given web type" do
    subject { described_class.new(query, type: type) }

    let(:query) { "wordpress +foo +bar" }
    let(:type) { "web" }

    describe "#artifacts" do
      it do
        expect(subject.artifacts).to be_an(Array)
      end
    end
  end

  context "when api config is not given" do
    before do
      allow(Mihari.config).to receive(:zoomeye_usernamme).and_return(nil)
      allow(Mihari.config).to receive(:zoomeye_password).and_return(nil)
    end

    it do
      expect { subject.artifacts }.to raise_error(ArgumentError)
    end
  end
end
