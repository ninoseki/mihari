# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Censys, :vcr do
  subject { described_class.new(query, tags: tags) }

  let(:query) { "ip:1.1.1.1" }
  let(:tags) { %w[test] }

  describe "#title" do
    it do
      expect(subject.title).to eq("Censys lookup")
    end
  end

  describe "#description" do
    it do
      expect(subject.description).to eq("query = #{query}")
    end
  end

  describe "#artifacts" do
    it do
      artifacts = subject.artifacts
      expect(artifacts).to be_an(Array)
      expect(artifacts.length).to eq(1)

      expect(artifacts.first).to eq("1.1.1.1")
    end
  end

  describe "#tags" do
    it do
      expect(subject.tags).to eq(tags)
    end
  end

  context "when api config is not given" do
    before do
      allow(Mihari.config).to receive(:censys_id).and_return(nil)
      allow(Mihari.config).to receive(:censys_secret).and_return(nil)
    end

    it do
      expect { subject.artifacts }.to raise_error(ArgumentError)
    end
  end
end
