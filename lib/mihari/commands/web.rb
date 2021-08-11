# frozen_string_literal: true

module Mihari
  module Commands
    module Web
      def self.included(thor)
        thor.class_eval do
          desc "web", "Launch the web app"
          method_option :port, type: :numeric, default: 9292
          method_option :host, type: :string, default: "localhost"
          method_option :config, type: :string, desc: "Path to the config file"
          def web
            port = options["port"].to_i || 9292
            host = options["host"] || "localhost"

            load_configuration

            # set rack env as production
            ENV["RACK_ENV"] ||= "production"

            Mihari::App.run!(port: port, host: host)
          end
        end
      end
    end
  end
end
