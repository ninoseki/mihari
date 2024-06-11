# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::DNSTwister, :vcr do
  subject(:analyzer) { described_class.new(query) }

  let!(:query) { "example.com" }

  describe "#artifacts" do
    before do
      # rubocop:disable RSpec/SubjectStub
      allow(analyzer).to receive(:resolvable?).and_return(true)
      # rubocop:enable RSpec/SubjectStub
    end

    it do
      expect(analyzer.artifacts).to be_an(Array)
    end
  end
end
