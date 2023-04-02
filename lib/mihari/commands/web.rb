# frozen_string_literal: true

module Mihari
  module Commands
    module Web
      def self.included(thor)
        thor.class_eval do
          desc "web", "Launch the web app"
          method_option :port, type: :numeric, default: 9292, desc: "Hostname to listen on"
          method_option :host, type: :string, default: "localhost", desc: "Port to listen on"
          method_option :threads, type: :string, default: "0:5", desc: "min:max threads to use"
          method_option :verbose, type: :boolean, default: true, desc: "Report each request"
          method_option :worker_timeout, type: :numeric, default: 60, desc: "Worker timeout value (in seconds)"
          method_option :hide_config_values, type: :boolean, default: false,
            desc: "Whether to hide config values or not"
          def web
            Mihari.config.hide_config_values = options["hide_config_values"]
            # set rack env as production
            ENV["RACK_ENV"] ||= "production"
            Mihari::App.run!(port: options["port"], host: options["host"], threads: options["threads"],
              verbose: options["verbose"], worker_timeout: options["worker_timeout"])
          end
        end
      end
    end
  end
end
