# frozen_string_literal: true

require "thor"
require "thor/hollaback"

# Commands
require "mihari/commands/alert"
require "mihari/commands/database"
require "mihari/commands/search"
require "mihari/commands/sidekiq"
require "mihari/commands/version"
require "mihari/commands/web"

# CLIs
require "mihari/cli/base"

require "mihari/cli/alert"
require "mihari/cli/artifact"
require "mihari/cli/config"
require "mihari/cli/database"
require "mihari/cli/rule"
require "mihari/cli/tag"

module Mihari
  module CLI
    #
    # Main CLI class
    #
    class App < Base
      class_option :debug, desc: "Set up debug mode", aliases: ["-d"], type: :boolean
      class_around :safe_execute

      include Mihari::Commands::Search
      include Mihari::Commands::Sidekiq
      include Mihari::Commands::Version
      include Mihari::Commands::Web

      include Concerns::ErrorUnwrappable

      no_commands do
        #
        # @param [StandardError] error
        #
        # @return [String, Hash, nil]
        #
        def error_to_detail(error)
          # Dirty hack to show the DB error message
          # (NOTE: #safe_execute block suppress #with_db_connection's error message)
          if error.is_a?(ActiveRecord::StatementInvalid)
            return "DB migration is not yet complete. Please run 'mihari db migrate'."
          end

          error.respond_to?(:detail) ? error.detail : nil
        end

        def safe_execute
          yield
        rescue StandardError => e
          error = unwrap_error(e)

          # Raise error if it's a Thor::Error to follow Thor's manner
          raise error if error.is_a?(Thor::Error)
          # Raise error if debug is set as true
          raise error if options["debug"]

          data = Entities::ErrorMessage.represent(message: error.message, detail: error_to_detail(error))
          warn JSON.pretty_generate(data.as_json)

          Sentry.capture_exception(error) if Sentry.initialized? && !error.is_a?(ValidationError)

          exit 1
        end
      end

      desc "db", "Sub commands for DB"
      subcommand "db", Database

      desc "rule", "Sub commands for rule"
      subcommand "rule", Rule

      desc "alert", "Sub commands for alert"
      subcommand "alert", Alert

      desc "artifact", "Sub commands for artifact"
      subcommand "artifact", Artifact

      desc "tag", "Sub commands for tag"
      subcommand "tag", Tag

      desc "config", "Sub commands for config"
      subcommand "config", Config
    end
  end
end
