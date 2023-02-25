# frozen_string_literal: true

require "thor"

# Commands
require "mihari/commands/searcher"
require "mihari/commands/version"
require "mihari/commands/web"
require "mihari/commands/database"

# CLIs
require "mihari/cli/base"

require "mihari/cli/database"
require "mihari/cli/rule"

module Mihari
  module CLI
    class Main < Base
      include Mihari::Commands::Searcher
      include Mihari::Commands::Version
      include Mihari::Commands::Web

      desc "database", "Sub commands for database"
      subcommand "db", Database

      desc "rule", "Sub commands for rule"
      subcommand "rule", Rule
    end
  end
end
