# frozen_string_literal: true

module Mihari
  module Mixins
    module Retriable
      DEFAULT_ON = [
        Errno::ECONNRESET,
        Errno::ECONNABORTED,
        Errno::EPIPE,
        OpenSSL::SSL::SSLError,
        Timeout::Error,
        RetryableError,
        NetworkError,
        TimeoutError
      ]

      #
      # Retry on error
      #
      # @param [Integer] times
      # @param [Integer] interval
      # @param [Array<StandardError>] on
      #
      # @return [nil]
      #
      def retry_on_error(times: 3, interval: 5, on: DEFAULT_ON)
        try = 0
        begin
          try += 1
          yield
        rescue *on => e
          sleep interval
          retry if try < times
          raise e
        end
      end
    end
  end
end
