# frozen_string_literal: true

class CLI < Mihari::CLI::Base
  include Mihari::Commands::Version
end

RSpec.describe Mihari::Commands::Version do
  describe "#__print_version" do
    it do
      expect { CLI.start ["--version"] }.to output(/#{Mihari::VERSION}/).to_stdout
    end

    it do
      expect { CLI.start ["-v"] }.to output(/#{Mihari::VERSION}/).to_stdout
    end
  end
end
