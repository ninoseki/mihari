# frozen_string_literal: true

class ConfigCLI < Mihari::CLI::Base
  include Mihari::Commands::Config
end

RSpec.describe Mihari::Commands::Config do
  include_context "with database fixtures"

  let!(:key) { Mihari.config.keys.first }

  describe "#list" do
    it do
      expect { ConfigCLI.start ["list"] }.to output(include(key)).to_stdout
    end
  end
end
