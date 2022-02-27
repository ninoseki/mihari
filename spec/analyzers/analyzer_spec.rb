# frozen_string_literal: true

require "stringio"

class Test < Mihari::Analyzers::Base
  public :normalized_artifacts

  def artifacts
    %w[1.1.1.1 google.com 2.2.2.2 example.com nil]
  end

  def description
    "test"
  end
end

RSpec.describe Mihari::Analyzers::Base, :vcr do
  subject { Test.new }

  describe "#title" do
    it do
      expect(subject.title).to eq("Test")
    end
  end

  describe "#description" do
    it do
      expect(subject.description).to eq("test")
    end
  end

  describe "#artifacts" do
    it do
      expect(subject.artifacts).to eq(%w[1.1.1.1 google.com 2.2.2.2 example.com nil])
    end
  end

  describe "#artifacts" do
    it do
      artifacts = %w[1.1.1.1 2.2.2.2 example.com google.com]
      expect(subject.normalized_artifacts.map(&:data)).to eq(artifacts)
    end
  end

  describe "#run" do
    before do
      # mock artifact enrichments
      subject.normalized_artifacts.each do |artifact|
        allow(artifact).to receive(:enrich_all).and_return(nil)
      end

      # set an empty array as emitters
      allow(Mihari).to receive(:emitters).and_return([])

      allow(Parallel).to receive(:processor_count).and_return(0)
    end

    it "doens't raise any error" do
      capture(:stderr) { subject.run }
    end

    context "when a notifer raises an error" do
      let(:sio) { StringIO.new }

      let(:logger) do
        SemanticLogger.default_level = :info
        SemanticLogger.add_appender(io: sio, formatter: :color)
        SemanticLogger["Mihari"]
      end

      before do
        # mock artifact enrichments
        subject.normalized_artifacts.each do |artifact|
          allow(artifact).to receive(:enrich_all).and_return(nil)
        end

        # mock emitters
        emitter = double("emitter_instance")
        allow(emitter).to receive(:valid?).and_return(true)
        allow(emitter).to receive(:run).and_raise("error")

        klass = double("emitter_class")
        allow(klass).to receive(:new).and_return(emitter)

        # set mocked classes as emitters
        allow(Mihari).to receive(:emitters).and_return([klass])
        allow(Parallel).to receive(:processor_count).and_return(0)

        allow(Mihari).to receive(:logger).and_return(logger)
      end

      it do
        subject.run

        # read logger output
        SemanticLogger.flush
        sio.rewind
        output = sio.read

        expect(output).to include("Emission by")
      end
    end
  end
end
