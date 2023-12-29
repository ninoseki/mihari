# frozen_string_literal: true

module Mihari
  module Concerns
    #
    # Retriable concern
    #
    module Retriable
      extend ActiveSupport::Concern

      DEFAULT_ON = [
        Errno::ECONNRESET,
        Errno::ECONNABORTED,
        Errno::EPIPE,
        OpenSSL::SSL::SSLError,
        Timeout::Error,
        RetryableError,
        NetworkError,
        TimeoutError,
        StatusCodeError
      ].freeze

      #
      # Retry on error
      #
      # @param [Integer] times
      # @param [Integer] interval
      # @param [Boolean] exponential_backoff
      # @param [Array<StandardError>] on
      #
      def retry_on_error(times: 3, interval: 5, exponential_backoff: true, on: DEFAULT_ON)
        try = 0
        begin
          try += 1
          yield
        rescue *on => e
          sleep_seconds = exponential_backoff ? interval * (2**(try - 1)) : interval
          sleep sleep_seconds
          retry if try < times
          raise e
        end
      end
    end
  end
end
