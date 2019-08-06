# frozen_string_literal: true

module Mihari
  module Emitters
    class Base
      def self.inherited(child)
        Mihari.emitters << child
      end

      # @return [true, false]
      def valid?
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def emit(title:, description:, artifacts:)
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end
    end
  end
end
