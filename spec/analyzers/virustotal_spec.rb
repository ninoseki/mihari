# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::VirusTotal, :vcr do
  let(:tags) { %w[test] }

  context "ipv4" do
    subject { described_class.new(query, tags: tags) }

    let(:query) { "45.83.140.140" }

    describe "#title" do
      it do
        expect(subject.title).to eq("VirusTotal search")
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
  end

  context "domain" do
    subject { described_class.new(query, tags: tags) }

    let(:query) { "jppost-ge.top" }

    describe "#artifacts" do
      it do
        expect(subject.artifacts).to be_an(Array)
      end
    end
  end

  context "when given an invalid input" do
    subject { described_class.new(query, tags: tags) }

    let(:query) { "foo bar" }

    describe "#artifacts" do
      it do
        expect { subject.artifacts }.to raise_error(Mihari::InvalidInputError)
      end
    end
  end

  context "when api config is not given" do
    before do
      allow(Mihari.config).to receive(:virustotal_api_key).and_return(nil)
    end

    it do
      expect { subject.artifacts }.to raise_error(ArgumentError)
    end
  end
end
