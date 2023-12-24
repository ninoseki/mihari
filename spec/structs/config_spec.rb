# frozen_string_literal: true

RSpec.describe Mihari::Structs::Config do
  describe ".from_class" do
    subject(:config) { described_class.from_class(Mihari::Emitters::Database) }

    it do
      expect(config.name).to eq("database")
    end

    it do
      expect(config.configured).to be true
    end
  end
end
