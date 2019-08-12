# frozen_string_literal: true

RSpec.describe Mihari::TheHive::Alert, :vcr do
  subject { described_class.new }

  describe "#list" do
    it do
      results = subject.list(range: "0-1")
      expect(results).to be_an(Array)
    end
  end
end
