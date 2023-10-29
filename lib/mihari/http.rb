# frozen_string_literal: true

require "http"

module Mihari
  module HTTP
    #
    # Better error handling feature
    #
    class BetterError < ::HTTP::Feature
      def wrap_response(response)
        unless response.status.success?
          raise StatusCodeError.new(
            "Unsuccessful response code returned: #{response.code}",
            response.code,
            response.body.to_s
          )
        end
        response
      end

      def on_error(_request, error)
        raise TimeoutError, error if error.is_a?(::HTTP::TimeoutError)
        raise NetworkError, error if error.is_a?(::HTTP::Error)
      end

      ::HTTP::Options.register_feature(:better_error, self)
    end

    #
    # HTTP client factory
    #
    class Factory
      class << self
        #
        # @param [Integer, nil] timeout
        # @param [Hash] headers
        #
        # @return [::HTTP::Client]
        #
        def build(headers: {}, timeout: nil)
          client = ::HTTP.use(:better_error).headers(headers)
          client.timeout(timeout) unless timeout.nil?
          client
        end
      end
    end
  end
end
