# frozen_string_literal: true

RSpec.describe Mihari::CLI::Config do
  let!(:key) { Mihari.config.keys.first.upcase }

  describe "#list" do
    it do
      expect { described_class.new.invoke(:list) }.to output(include(key)).to_stdout
    end
  end
end
