# frozen_string_literal: true

module Mihari
  module Commands
    #
    # Web sub-commands
    #
    module Web
      class << self
        def included(thor)
          thor.class_eval do
            desc "web", "Start the web app"
            method_option :port, type: :numeric, default: 9292, desc: "Port to listen on"
            method_option :host, type: :string, default: "localhost", desc: "Hostname to listen on"
            method_option :threads, type: :string, default: "0:5", desc: "min:max threads to use"
            method_option :verbose, type: :boolean, default: false, desc: "Don't report each request"
            method_option :worker_timeout, type: :numeric, default: 60, desc: "Worker timeout value (in seconds)"
            method_option :open, type: :boolean, default: true, desc: "Whether to open the app in browser or not"
            method_option :env, type: :string, default: "production", desc: "Environment"
            def web
              require "mihari/web/application"

              ENV["APP_ENV"] ||= options["env"]

              Mihari::Web::App.run!(
                port: options["port"],
                host: options["host"],
                threads: options["threads"],
                verbose: options["verbose"],
                worker_timeout: options["worker_timeout"],
                open: options["open"]
              )
            end
          end
        end
      end
    end
  end
end
