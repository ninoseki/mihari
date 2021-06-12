# frozen_string_literal: true

require "thor"

require "mihari/commands/config"
require "mihari/commands/search"
require "mihari/commands/web"

require "mihari/mixins/hash"
require "mihari/cli/mixins/utils"

module Mihari
  module CLI
    class Main < Base
      include Mihari::Mixins::Hash
      include Mixins::Utils

      include Mihari::Commands::Config
      include Mihari::Commands::Search
      include Mihari::Commands::Web

      desc "analyzer", "Sub commands to run an analyzer"
      subcommand "analyzer", Analyzer
    end
  end
end
