# frozen_string_literal: true

module Mihari
  module Notifiers
    class Base
      # @return [true, false]
      def valid?
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def notify
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end
    end
  end
end
