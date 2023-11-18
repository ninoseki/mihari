# frozen_string_literal: true

module Mihari
  module Web
    module Middleware
      #
      # Error notification adapter for Rack app
      #
      class ErrorNotificationAdapter
        include Mihari::Mixins::UnwrapError

        attr_reader :app

        def initialize(app)
          @app = app
        end

        def with_error_notification
          yield
        rescue StandardError => e
          unwrapped = unwrap_error(e)

          Mihari.logger.error unwrapped
          Sentry.capture_exception(unwrapped) if Sentry.initialized?

          raise unwrapped
        end

        def call(env)
          with_error_notification { app.call(env) }
        end
      end
    end
  end
end
