# frozen_string_literal: true

module Mihari
  module Web
    module Middleware
      #
      # Customized Sentry::Rack::CaptureExceptions
      #
      class CaptureExceptions < Sentry::Rack::CaptureExceptions
        include Mihari::Mixins::UnwrapError

        private

        def capture_exception(exception, env)
          unwrapped = unwrap_error(exception)
          Mihari.logger.error unwrapped

          Sentry.capture_exception(unwrapped).tap do |event|
            env[ERROR_EVENT_ID_KEY] = event.event_id if event
          end
        end
      end
    end
  end
end
