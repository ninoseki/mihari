# frozen_string_literal: true

class VersionCLI < Mihari::CLI::Base
  include Mihari::Commands::Version
end

RSpec.describe Mihari::Commands::Version do
  describe "#__print_version" do
    it do
      expect { VersionCLI.start ["--version"] }.to output(/#{Mihari::VERSION}/o).to_stdout
    end

    it do
      expect { VersionCLI.start ["-v"] }.to output(/#{Mihari::VERSION}/o).to_stdout
    end
  end
end
