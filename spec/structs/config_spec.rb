# frozen_string_literal: true

RSpec.describe Mihari::Structs::Config do
  describe ".from_class" do
    it do
      config = described_class.from_class(Mihari::Emitters::Database)
      expect(config.name).to eq("Database")
      expect(config.is_configured).to be true
    end
  end
end
