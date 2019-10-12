# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Censys, :vcr do
  subject { described_class.new(query, tags: tags) }

  let(:query) { "sagawa.apk" }
  let(:tags) { %w(test) }

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
      expect(subject.artifacts).to be_an(Array)
    end
  end

  describe "#tags" do
    it do
      expect(subject.tags).to eq(tags)
    end
  end

  context "when given certificates type" do
    subject { described_class.new(query, type: type) }

    let(:query) { "15fbb68a8ddb119c371a869c35fd36cf7a77f304b23e46e824fd7d39bcb50a68" }
    let(:type) { "certificates" }

    describe "#artifacts" do
      it do
        expect(subject.artifacts).to be_an(Array)
      end
    end
  end

  context "when given websites type" do
    subject { described_class.new(query, type: type) }

    let(:query) { "domain:dropbox.com" }
    let(:type) { "websites" }

    describe "#artifacts" do
      it do
        expect(subject.artifacts).to be_an(Array)
      end
    end
  end
end
