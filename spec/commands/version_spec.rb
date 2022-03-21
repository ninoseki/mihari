# frozen_string_literal: true

class CLI < Mihari::CLI::Base
  include Mihari::Commands::Version
end

RSpec.describe Mihari::Commands::Version do
  describe "#__print_version" do
    it do
      output = capture(:stdout) { CLI.start ["--version"] }.chomp
      expect(output).to eq(Mihari::VERSION.to_s)
    end

    it do
      output = capture(:stdout) { CLI.start ["-v"] }.chomp
      expect(output).to eq(Mihari::VERSION.to_s)
    end
  end
end
