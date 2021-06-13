# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Crtsh, :vcr do
  subject { described_class.new(query, tags: tags) }

  let(:query) { "crt.sh" }
  let(:tags) { %w[test] }

  describe "#title" do
    it do
      expect(subject.title).to eq("crt.sh search")
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
