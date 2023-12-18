# frozen_string_literal: true

require "glint"
require "webrick"

module Spec
  module Support
    module Helpers
      def server_builder
        host = "localhost"

        Glint::Server.new do |port|
          http = WEBrick::HTTPServer.new(
            BindAddress: host,
            Port: port,
            Logger: WEBrick::Log.new(File.open(File::NULL, "w")),
            AccessLog: []
          )

          yield http

          trap(:INT) { http.shutdown }
          trap(:TERM) { http.shutdown }

          http.start
        end
      end
    end
  end
end
