# frozen_string_literal: true

class VersionCLI < Mihari::CLI::Base
  include Mihari::Commands::Version
end

RSpec.describe Mihari::Commands::Version do
  describe "#__print_version" do
    it do
      expect { VersionCLI.start ["--version"] }.to output(include(Mihari::VERSION)).to_stdout
    end

    it do
      expect { VersionCLI.start ["-v"] }.to output(include(Mihari::VERSION)).to_stdout
    end

    it do
      expect { VersionCLI.new.invoke(:__print_version) }.to output(include(Mihari::VERSION)).to_stdout
    end
  end
end
