# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Onyphe, :vcr do
  subject { described_class.new(query, tags: tags) }

  let(:query) { "4299114377898569169" }
  let(:tags) { %w(test) }

  describe "#title" do
    it do
      expect(subject.title).to eq("Onyphe lookup")
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
    end
  end

  describe "#tags" do
    it do
      expect(subject.tags).to eq(tags)
    end
  end

  context "when api config is not given" do
    before do
      allow(ENV).to receive(:[]).with("ONYPHE_API_KEY").and_return(nil)
    end

    it do
      expect { subject.artifacts }.to raise_error(ArgumentError)
    end
  end
end
