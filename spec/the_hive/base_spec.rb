# frozen_string_literal: true

RSpec.describe Mihari::TheHive::Base do
  subject { described_class.new }

  describe "#api" do
    it do
      expect(subject.api).to be_a(Hachi::API)
    end
  end
end
