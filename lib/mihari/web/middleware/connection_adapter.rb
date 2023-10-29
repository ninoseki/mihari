# frozen_string_literal: true

module Mihari
  module Web
    module Middleware
      #
      # DB connection adapter for Rack app
      #
      class ConnectionAdapter
        def initialize(app)
          @app = app
        end

        def call(env)
          Mihari::Database.with_db_connection do
            status, headers, body = @app.call(env)

            [status, headers, body]
          end
        end
      end
    end
  end
end
