# frozen_string_literal: true

module Mihari
  module Notifiers
    class Base
      # Validate notifier availability
      #
      # @return [Boolean]
      #
      def valid?
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      #
      # Send a notification
      #
      # @return [nil]
      #
      def notify
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end
    end
  end
end
