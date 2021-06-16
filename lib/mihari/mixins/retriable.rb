# frozen_string_literal: true

module Mihari
  module Mixins
    module Retriable
      #
      # Retry on error
      #
      # @param [Integer] times
      # @param [Integer] interval
      #
      # @return [nil]
      #
      def retry_on_error(times: 3, interval: 10)
        try = 0
        begin
          try += 1
          yield
        rescue Errno::ECONNRESET, Errno::ECONNABORTED, Errno::EPIPE, OpenSSL::SSL::SSLError, Timeout::Error, RetryableError => e
          sleep interval
          retry if try < times
          raise e
        end
      end
    end
  end
end
