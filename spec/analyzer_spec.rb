# frozen_string_literal: true

RSpec.describe Mihari::Analyzer, :vcr do
  class Test < Mihari::Analyzer
    def artifacts
      [Mihari::Artifact.new("1.1.1.1"), Mihari::Artifact.new("google.com")]
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

  describe "#run" do
    it "doens't raise any error" do
      subject.run
    end
  end
end
