# frozen_string_literal: true

require "thor"

require "mihari/commands/config"
require "mihari/commands/search"
require "mihari/commands/validate"
require "mihari/commands/web"

module Mihari
  module CLI
    class Main < Base
      include Mihari::Commands::Config
      include Mihari::Commands::Search
      include Mihari::Commands::Validate
      include Mihari::Commands::Web

      desc "analyzer", "Sub commands to run an analyzer"
      subcommand "analyzer", Analyzer
    end
  end
end
