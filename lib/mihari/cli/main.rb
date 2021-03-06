# frozen_string_literal: true

# Commands
require "mihari/commands/search"
require "mihari/commands/web"

# CLIs
require "mihari/cli/base"

require "mihari/cli/analyzer"
require "mihari/cli/init"
require "mihari/cli/validator"

module Mihari
  module CLI
    class Main < Base
      include Mihari::Commands::Search
      include Mihari::Commands::Web

      desc "analyze", "Sub commands to run an analyzer"
      subcommand "analyze", Analyzer

      desc "init", "Sub commands to initialize config & rule"
      subcommand "init", Initialization

      desc "validate", "Sub commands to validate format of config & rule"
      subcommand "validate", Validator
    end
  end
end
