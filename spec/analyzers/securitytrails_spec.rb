# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::SecurityTrails, :vcr do
  let(:tags) { %w(test) }

  context "when given an ipv4" do
    subject { described_class.new(query, tags: tags) }

    let(:query) { "89.35.39.84" }

    describe "#title" do
      it do
        expect(subject.title).to eq("SecurityTrails lookup")
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

  context "when given a domain" do
    subject { described_class.new(query, tags: tags) }

    let(:query) { "jppost-tu.top" }

    describe "#artifacts" do
      it do
        expect(subject.artifacts).to be_an(Array)
      end
    end
  end

  context "when given a mail" do
    subject { described_class.new(query, tags: tags) }

    let(:query) { "test@test.com" }

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
      allow(ENV).to receive(:[]).with("SECURITYTRAILS_API_KEY").and_return(nil)
    end

    it do
      expect { subject.artifacts }.to raise_error(ArgumentError)
    end
  end
end
