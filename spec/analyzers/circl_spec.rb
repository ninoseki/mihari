# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::CIRCL, :vcr do
  let(:tags) { %w[test] }

  context "when given a domain" do
    subject { described_class.new(query, tags: tags) }

    let(:query) { "www.circl.lu" }

    describe "#title" do
      it do
        expect(subject.title).to eq("CIRCL passive DNS/SSL search")
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

  context "when given a hash" do
    subject { described_class.new(query, tags: tags) }

    let(:query) { "7c552ab044c76d1df4f5ddf358807bfdcd07fa57" }

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
      allow(Mihari.config).to receive(:circl_passive_password).and_return(nil)
      allow(Mihari.config).to receive(:circl_passive_username).and_return(nil)
    end

    it do
      expect { subject.artifacts }.to raise_error(ArgumentError)
    end
  end
end
