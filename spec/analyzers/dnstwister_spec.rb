# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::DNSTwister, :vcr do
  subject { described_class.new(query, tags: tags) }

  let(:tags) { %w(test) }
  let(:query) { "example.com" }

  describe "#artifacts" do
    it do
      expect(subject.artifacts).to be_an(Array)
    end
  end
end
