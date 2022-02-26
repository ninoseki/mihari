# frozen_string_literal: true

module Mihari
  module Emitters
    class Base
      include Mixins::Configurable
      include Mixins::Retriable

      class << self
        def inherited(child)
          super
          Mihari.emitters << child
        end
      end

      # @return [Boolean]
      def valid?
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      def run(**params)
        retry_on_error { emit(**params) }
      end

      def emit(*)
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end
    end
  end
end
