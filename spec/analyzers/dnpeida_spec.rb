# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::DNPedia, :vcr do
  let(:tags) { %w(test) }
  let(:query) { "%apple%" }

  subject { described_class.new(query, tags: tags) }

  describe "#artifacts" do
    it do
      subject.artifacts
    end
  end
end
