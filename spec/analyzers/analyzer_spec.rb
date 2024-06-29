# frozen_string_literal: true

class AnalyzerTest < Mihari::Analyzers::Base
  public :normalized_artifacts

  def initialize(query = "dummy")
    super
  end

  def artifacts
    values = %w[1.1.1.1 1.1.1.1 google.com 2.2.2.2 example.com foo]
    values << nil
    values
  end

  class << self
    def keys
      # NOTE: returns an empty array to prevent adding this class in Mihari#analyzer_to_class
      []
    end
  end
end

RSpec.describe Mihari::Analyzers::Base, :vcr do
  subject(:test) { AnalyzerTest.new }

  describe "#artifacts" do
    it do
      expect(test.artifacts).to eq(
        [
          "1.1.1.1", "1.1.1.1", "google.com", "2.2.2.2", "example.com", "foo", nil
        ]
      )
    end
  end

  describe "#normalized_artifacts" do
    it do
      expect(test.normalized_artifacts.map(&:data)).to eq(%w[1.1.1.1 2.2.2.2 example.com google.com])
    end
  end

  describe "#truncated_query" do
    it do
      analyzer = AnalyzerTest.new(Faker::String.random(length: 64))
      expect(analyzer.truncated_query.length).to eq(32)
    end
  end
end
