# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Base, :vcr do
  class Test < Mihari::Analyzers::Base
    def artifacts
      %w(1.1.1.1 google.com)
    end

    def description
      "test"
    end
  end

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
      expect(subject.artifacts).to eq(%w(1.1.1.1 google.com))
    end
  end

  describe "#run" do
    it "doens't raise any error" do
      capture(:stdout) { subject.run }
    end

    context "when a notifer raises an error" do
      before do
        notifier = double("notifier_instance")
        allow(notifier).to receive(:valid?).and_return(true)
        allow(notifier).to receive(:notify).and_raise("error")

        klass = double("notifier_class")
        allow(klass).to receive(:new).and_return(notifier)

        allow(Mihari).to receive(:notifiers).and_return([klass])

        thehive = instance_double(Mihari::TheHive)
        allow(thehive).to receive(:valid?).and_return(false)
        allow(Mihari::TheHive).to receive(:new).and_return(thehive)
      end

      it do
        output = capture(:stdout){ subject.run }
        expect(output).to include("Sending notification by")
      end
    end
  end
end
