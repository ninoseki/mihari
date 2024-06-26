# frozen_string_literal: true

RSpec.describe Mihari::CLI::Database do
  describe "#migrate" do
    it do
      expect { described_class.new.invoke(:migrate) }.to output(include("migrate")).to_stdout
    end
  end
end
