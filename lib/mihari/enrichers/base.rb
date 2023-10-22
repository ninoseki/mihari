# frozen_string_literal: true

module Mihari
  module Enrichers
    class Base < Mihari::Base
      include Mixins::Configurable
      include Mixins::Retriable

      include Dry::Monads[:result, :try]

      def initialize(options: nil)
        super(options: options)
      end

      def query_result(value)
        Try[StandardError] do
          retry_on_error(
            times: retry_times,
            interval: retry_interval,
            exponential_backoff: retry_exponential_backoff
          ) { query value }
        end.to_result
      end

      #
      # @param [String] value
      #
      def query(value)
        raise NotImplementedError, "You must implement #{self.class}##{__method__}"
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
