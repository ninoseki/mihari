# frozen_string_literal: true

require "cymbal"
require "thor"

require "mihari/commands/mixins/utils"

require "mihari/commands/config"
require "mihari/commands/search"
require "mihari/commands/web"

require "mihari/cli/mixins/utils"

require "mihari/cli/service"

module Mihari
  module CLI
    class Main < Thor
      include Mixins::Utils

      class_option :config, type: :string, desc: "Path to the config file"

      class_option :ignore_old_artifacts, type: :boolean, default: false, desc: "Whether to ignore old artifacts from checking or not. Only affects with analyze commands."
      class_option :ignore_threshold, type: :numeric, default: 0, desc: "Number of days to define whether an artifact is old or not. Only affects with analyze commands."

      include Mihari::Commands::Config
      include Mihari::Commands::Search
      include Mihari::Commands::Web

      desc "service", "Sub commands to run a service"
      subcommand "service", Service

      class << self
        def exit_on_failure?
          true
        end
      end
    end
  end
end
