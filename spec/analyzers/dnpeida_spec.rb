# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::DNPedia, :vcr do
  subject { described_class.new(query, tags: tags) }

  let(:tags) { %w(test) }
  let(:query) { "%apple%" }

  describe "#artifacts" do
    it do
      subject.artifacts
    end
  end
end
