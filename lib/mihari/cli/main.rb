# frozen_string_literal: true

require "thor"

# Commands
require "mihari/commands/alert"
require "mihari/commands/database"
require "mihari/commands/search"
require "mihari/commands/version"
require "mihari/commands/web"

# CLIs
require "mihari/cli/base"

require "mihari/cli/alert"
require "mihari/cli/database"
require "mihari/cli/rule"

module Mihari
  module CLI
    class Main < Base
      include Mihari::Commands::Search
      include Mihari::Commands::Version
      include Mihari::Commands::Web

      desc "db", "Sub commands for DB"
      subcommand "db", Database

      desc "rule", "Sub commands for rule"
      subcommand "rule", Rule

      desc "alert", "Sub commands for alert"
      subcommand "alert", Alert
    end
  end
end
