# frozen_string_literal: true

require "thor"

# Commands
require "mihari/commands/initializer"
require "mihari/commands/searcher"
require "mihari/commands/validator"
require "mihari/commands/version"
require "mihari/commands/web"

# CLIs
require "mihari/cli/base"

module Mihari
  module CLI
    class Main < Base
      include Mihari::Commands::Searcher
      include Mihari::Commands::Version
      include Mihari::Commands::Web
      include Mihari::Commands::Validator
      include Mihari::Commands::Initializer
    end
  end
end
