# frozen_string_literal: true

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
    end

    it "doens't raise any error" do
      capture(:stdout) { subject.run }
    end

    context "when a notifer raises an error" do
      before do
        # mock emitters
        emitter = double("emitter_instance")
        allow(emitter).to receive(:valid?).and_return(true)
        allow(emitter).to receive(:run).and_raise("error")

        klass = double("emitter_class")
        allow(klass).to receive(:new).and_return(emitter)

        allow(Mihari).to receive(:emitters).and_return([klass])

        thehive = instance_double(Mihari::Emitters::TheHive)
        allow(thehive).to receive(:valid?).and_return(false)
        allow(Mihari::Emitters::TheHive).to receive(:new).and_return(thehive)

        allow(Parallel).to receive(:processor_count).and_return(0)
      end

      it do
        output = capture(:stdout) { subject.run }
        expect(output).to include("Emission by")
      end
    end
  end
end
