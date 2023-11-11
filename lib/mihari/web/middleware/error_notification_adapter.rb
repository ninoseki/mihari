# frozen_string_literal: true

module Mihari
  module Web
    module Middleware
      #
      # Error notification adapter for Rack app
      #
      class ErrorNotificationAdapter
        def initialize(app)
          @app = app
        end

        def with_error_notification
          yield
        rescue StandardError => e
          Mihari.logger.error e

          Sentry.capture_exception(e) if Sentry.initialized?
        end

        def call(env)
          with_error_notification do
            status, headers, body = @app.call(env)
            [status, headers, body]
          end
        end
      end
    end
  end
end
