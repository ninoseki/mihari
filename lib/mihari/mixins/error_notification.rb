# frozen_string_literal: true

module Mihari
  module Mixins
    module ErrorNotification
      #
      # Send an exception notification if there is any error in a block
      #
      def with_error_notification
        yield
      rescue StandardError => e
        Mihari.logger.error e

        Sentry.capture_exception(e) if Sentry.initialized?
      end
    end
  end
end
