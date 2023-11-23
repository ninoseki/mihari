# frozen_string_literal: true

module Mihari
  module Enrichers
    #
    # Base class for enrichers
    #
    class Base < Actor
      prepend MemoWise

      def initialize(options: nil)
        super(options: options)
      end

      #
      # @param [String] value
      #
      def call(value)
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
      end

      #
      # @return [Dry::Monads::Result::Success<Object>, Dry::Monads::Result::Failure]
      #
      def result(value)
        Try[StandardError] do
          retry_on_error(
            times: retry_times,
            interval: retry_interval,
            exponential_backoff: retry_exponential_backoff
          ) { call value }
        end.to_result
      end

      class << self
        def inherited(child)
          super
          Mihari.enrichers << child
        end
      end
    end
  end
end
