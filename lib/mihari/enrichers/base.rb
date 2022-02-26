# frozen_string_literal: true

module Mihari
  module Enrichers
    class Base
      include Mixins::Configurable

      class << self
        def inherited(child)
          super
          Mihari.enrichers << child
        end
      end

      # @return [Boolean]
      def valid?
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end
    end
  end
end
