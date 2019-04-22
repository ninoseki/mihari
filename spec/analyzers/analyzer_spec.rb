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
  end
end
