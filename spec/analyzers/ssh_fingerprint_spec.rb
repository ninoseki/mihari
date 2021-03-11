# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::SSHFingerprint do
  subject { described_class.new(fingerprint, tags: tags) }

  let(:tags) { %w[test] }

  let(:fingerprint) { "62:5e:b9:fd:3a:70:eb:37:99:e9:12:e3:d9:3f:4e:6c" }

  let(:mock) { instance_double("Analyzer") }

  before do
    allow(mock).to receive(:artifacts).and_return([])

    allow(Mihari::Analyzers::BinaryEdge).to receive(:new).with("ssh.fingerprint:\"#{fingerprint}\"").and_return(mock)
    allow(Mihari::Analyzers::Shodan).to receive(:new).with(fingerprint).and_return(mock)
  end

  describe "#title" do
    it do
      expect(subject.title).to eq("SSH fingerprint cross search")
    end
  end

  describe "#description" do
    it do
      expect(subject.description).to eq("fingerprint = #{fingerprint}")
    end
  end

  describe "#artifacts" do
    before do
      allow(Parallel).to receive(:processor_count).and_return(0)
    end

    it do
      expect(subject.artifacts).to be_an(Array)
    end
  end

  describe "#tags" do
    it do
      expect(subject.tags).to eq(tags)
    end
  end

  context "when given an invalid input" do
    subject { described_class.new("foo") }

    describe "#artifacts" do
      it do
        expect { subject.artifacts }.to raise_error(Mihari::InvalidInputError)
      end
    end
  end
end
