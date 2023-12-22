# frozen_string_literal: true

module Mihari
  module Web
    module Middleware
      #
      # DB connection adapter for Rack app
      #
      class Connection
        attr_reader :app

        def initialize(app)
          @app = app
        end

        def call(env)
          Mihari::Database.with_db_connection { app.call env }
        end
      end
    end
  end
end
