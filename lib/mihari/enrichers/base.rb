# frozen_string_literal: true

module Mihari
  module Enrichers
    class Base
      include Mixins::Configurable

      class << self
        include Dry::Monads[:result, :try]

        def inherited(child)
          super
          Mihari.enrichers << child
        end

        def query_result(value)
          Try[StandardError] { query(value) }.to_result
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
