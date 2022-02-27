# frozen_string_literal: true

module Mihari
  module Mixins
    module ErrorNotification
      #
      # Send an exception notification if there is any error in a block
      #
      # @return [Nil]
      #
      def with_error_notification
        yield
      rescue StandardError => e
        Mihari.logger.error e

        notifier = Notifiers::ExceptionNotifier.new
        notifier.notify(e) if notifier.valid?
      end
    end
  end
end
