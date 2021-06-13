# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::DNSTwister, :vcr do
  subject { described_class.new(query, tags: tags) }

  let(:tags) { %w[test] }
  let(:query) { "example.com" }

  describe "#artifacts" do
    before do
      allow(Resolv).to receive(:getaddress).and_return("1.1.1.1")
    end

    it do
      expect(subject.artifacts).to be_an(Array)
    end
  end

  describe "#title" do
    it do
      expect(subject.title).to eq("dnstwister domain search")
    end
  end

  describe "#description" do
    it do
      expect(subject.description).to eq("query = #{query}")
    end
  end
end
