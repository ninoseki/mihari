module Mihari
  module Middleware
    class ConnectionAdapter
      include Mixins::Database

      def initialize(app)
        @app = app
      end

      def call(env)
        with_db_connection do
          status, headers, body = @app.call(env)

          [status, headers, body]
        end
      end
    end
  end
end
