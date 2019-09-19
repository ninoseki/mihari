# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Base do
  subject { described_class.new }

  describe "#tags" do
    it do
      expect(subject.tags).to eq([])
    end
  end
end
