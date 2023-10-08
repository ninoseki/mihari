# frozen_string_literal: true

require "stringio"

class Test < Mihari::Analyzers::Base
  public :normalized_artifacts

  def initialize
    super("dummy")
  end

  def artifacts
    values = %w[1.1.1.1 1.1.1.1 google.com 2.2.2.2 example.com foo]
    values << nil
    values
  end
end

RSpec.describe Mihari::Analyzers::Base, :vcr do
  subject { Test.new }

  describe "#artifacts" do
    it do
      expect(subject.artifacts).to eq(
        [
          "1.1.1.1", "1.1.1.1", "google.com", "2.2.2.2", "example.com", "foo", nil
        ]
      )
    end
  end

  describe "#normalized_artifacts" do
    it do
      artifacts = %w[1.1.1.1 2.2.2.2 example.com google.com]
      expect(subject.normalized_artifacts.map(&:data)).to eq(artifacts)
    end
  end
end
