module Mihari
  module Commands
    #
    # Sidekiq sub-commands
    #
    module Sidekiq
      class << self
        def included(thor)
          thor.class_eval do
            desc "sidekiq", "Start Sidekiq"
            method_option :env, type: :string, default: "production", desc: "Environment"
            method_option :concurrency, type: :numeric, default: 5, desc: "Sidekiq concurrency", aliases: "-c"
            def sidekiq
              require "sidekiq/cli"

              ENV["APP_ENV"] ||= options["env"]
              concurrency = options["concurrency"].to_s

              cli = ::Sidekiq::CLI.instance
              cli.parse ["-r", File.expand_path(File.join(__dir__, "..", "sidekiq", "application.rb")), "-c",
                concurrency]
              cli.run
            end
          end
        end
      end
    end
  end
end
