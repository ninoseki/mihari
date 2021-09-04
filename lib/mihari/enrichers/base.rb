# frozen_string_literal: true

module Mihari
  module Enrichers
    class Base
      include Mixins::Configurable

      def self.inherited(child)
        Mihari.enrichers << child
      end

      # @return [Boolean]
      def valid?
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end
    end
  end
end
