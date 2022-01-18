# frozen_string_literal: true

require "thor"

# Commands
require "mihari/commands/search"
require "mihari/commands/web"

# CLIs
require "mihari/cli/base"

require "mihari/cli/init"
require "mihari/cli/validator"

module Mihari
  module CLI
    class Main < Base
      include Mihari::Commands::Search
      include Mihari::Commands::Web

      desc "init", "Sub commands to initialize a rule"
      subcommand "init", Initialization

      desc "validate", "Sub commands to validate format of a rule"
      subcommand "validate", Validator
    end
  end
end
