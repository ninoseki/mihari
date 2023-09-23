# frozen_string_literal: true

require "dry/monads"

module Mihari
  module Enrichers
    class Base
      include Mixins::Configurable

      class << self
        include Dry::Monads[:result]

        def inherited(child)
          super
          Mihari.enrichers << child
        end

        def query_result(value)
          Success query(value)
        rescue StandardError => e
          Failure e
        end

        #
        # @param [String] value
        #
        def query(value)
          raise NotImplementedError, "You must implement #{self.class}##{__method__}"
        end
      end

      # @return [Boolean]
      def valid?
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end
    end
  end
end
