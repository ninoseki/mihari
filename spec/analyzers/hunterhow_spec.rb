# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::HunterHow, :vcr do
  subject { described_class.new(query, start_time: start_time, end_time: end_time) }

  let!(:query) { 'ip:"1.1.1.1"' }
  let!(:start_time) { Date.parse "2023-08-01" }
  let!(:end_time) { Date.parse "2023-08-31" }

  describe "#artifacts" do
    it do
      artifacts = subject.artifacts
      expect(artifacts).to be_an(Array)
    end
  end
end
