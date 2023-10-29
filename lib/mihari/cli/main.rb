# frozen_string_literal: true

require "thor"
require "thor/hollaback"

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
    #
    # Main CLI class
    #
    class Main < Base
      class_option :debug, desc: "Sets up debug mode", aliases: ["-d"], type: :boolean
      class_around :safe_execute

      include Mihari::Commands::Search
      include Mihari::Commands::Version
      include Mihari::Commands::Web

      no_commands do
        def unwrap_error(err)
          return err unless err.is_a?(Dry::Monads::UnwrapError)

          # NOTE: UnwrapError's receiver can be either of:
          #       - Dry::Monads::Try::Error
          #       - Dry::Monads::Result::Failure
          receiver = err.receiver
          return receiver.exception if receiver.is_a?(Dry::Monads::Try::Error)

          receiver.failure
        end

        def safe_execute
          yield
        rescue StandardError => e
          err = unwrap_error(e)

          raise err if options["debug"]

          case err
          when ValidationError
            warn JSON.pretty_generate(err.errors.to_h)
          when StandardError
            Sentry.capture_exception(err) if Sentry.initialized?
            warn err
          end

          exit 1
        end
      end

      desc "db", "Sub commands for DB"
      subcommand "db", Database

      desc "rule", "Sub commands for rule"
      subcommand "rule", Rule

      desc "alert", "Sub commands for alert"
      subcommand "alert", Alert
    end
  end
end
