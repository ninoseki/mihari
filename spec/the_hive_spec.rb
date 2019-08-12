# frozen_string_literal: true

RSpec.describe Mihari::TheHive, :vcr do
  subject { described_class.new }

  describe "#valid?" do
    it do
      expect(subject).to be_valid
    end
  end
end
