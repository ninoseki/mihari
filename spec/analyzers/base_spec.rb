# frozen_string_literal: true

RSpec.describe Mihari::Analyzers::Base do
  subject { described_class.new }

  describe "#the_hive" do
    it do
      expect(subject.the_hive).to be_a(Mihari::TheHive)
    end
  end

  describe "#tags" do
    it do
      expect(subject.tags).to eq([])
    end
  end
end
