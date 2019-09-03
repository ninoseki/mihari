# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::SecurityTrails, :vcr do
  let(:tags) { %w(test) }

  context "ipv4" do
    subject { described_class.new(indicator, tags: tags) }

    let(:indicator) { "89.35.39.84" }

    describe "#title" do
      it do
        expect(subject.title).to eq("SecurityTrails lookup")
      end
    end

    describe "#description" do
      it do
        expect(subject.description).to eq("indicator = #{indicator}")
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
    subject { described_class.new(indicator, tags: tags) }

    let(:indicator) { "jppost-tu.top" }

    describe "#artifacts" do
      it do
        expect(subject.artifacts).to be_an(Array)
      end
    end
  end

  context "when given an invalid input" do
    subject { described_class.new(indicator, tags: tags) }

    let(:indicator) { "foo bar" }

    describe "#artifacts" do
      it do
        expect { subject.artifacts }.to raise_error(ArgumentError)
      end
    end
  end
end
