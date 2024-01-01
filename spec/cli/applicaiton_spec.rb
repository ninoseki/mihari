# frozen_string_literal: true

RSpec.describe Mihari::CLI::App do
  describe "#safe_execute" do
    it do
      expect do
        described_class.new.safe_execute { 1 / 0 }
      end.to raise_error SystemExit
    end

    it do
      res = described_class.new.safe_execute { 0 / 1 }
      expect(res).to eq(0)
    end
  end
end
