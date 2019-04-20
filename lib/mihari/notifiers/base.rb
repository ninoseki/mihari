# frozen_string_literal: true

module Mihari
  module Notifiers
    class Base
      def self.inherited(child)
        Mihari.notifiers << child
      end

      def valid?
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def notify(title:, description:, artifacts:)
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end
    end
  end
end
