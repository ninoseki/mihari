module Mihari
  module Commands
    module Web
      def self.included(thor)
        thor.class_eval do
          desc "web", "Launch the web app"
          method_option :port, type: :numeric, default: 9292
          method_option :host, type: :string, default: "localhost"
          def web
            port = options["port"].to_i || 9292
            host = options["host"] || "localhost"

            load_configuration
            Mihari::App.run!(port: port, host: host)
          end
        end
      end
    end
  end
end
