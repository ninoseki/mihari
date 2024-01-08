# frozen_string_literal: true

module Mihari
  module Concerns
    #
    # Retriable concern
    #
    module Retriable
      extend ActiveSupport::Concern

      RETRIABLE_ERRORS = [
        OpenSSL::SSL::SSLError,
        Timeout::Error,
        ::HTTP::ConnectionError,
        ::HTTP::ResponseError,
        ::HTTP::TimeoutError
      ].freeze

      DEFAULT_CONDITION = lambda do |error|
        return true if RETRIABLE_ERRORS.any? { |klass| error.is_a? klass }

        case error
        when StatusError
          ![401, 404].include?(error.status_code)
        else
          false
        end
      end

      #
      # Retry on error
      #
      # @param [Integer] times
      # @param [Integer] interval
      # @param [Boolean] exponential_backoff
      # @param [Proc] condition
      #
      # @param [Object] on
      def retry_on_error(times: 3, interval: 5, exponential_backoff: true, condition: DEFAULT_CONDITION)
        try = 0
        begin
          try += 1
          yield
        rescue StandardError => e
          # Raise error if it's not a retriable error
          raise e unless condition.call(e)

          sleep_seconds = exponential_backoff ? interval * (2**(try - 1)) : interval
          sleep sleep_seconds
          retry if try < times

          # Raise error if retry times exceed a given times
          raise e
        end
      end
    end
  end
end
