# frozen_string_literal: true

require "http"

module Mihari
  module HTTP
    #
    # Better error handling feature
    #
    class BetterError < ::HTTP::Feature
      def wrap_response(response)
        return response if response.status.success?

        raise StatusError.new(
          "Unsuccessful response code returned: #{response.code}",
          response.code,
          response.body.to_s
        )
      end

      ::HTTP::Options.register_feature(:better_error, self)
    end

    #
    # HTTP client factory
    #
    class Factory
      class << self
        USER_AGENT = "mihari/#{Mihari::VERSION}".freeze
        #
        # @param [Integer, nil] timeout
        # @param [Hash] headers
        # @param [Boolean] raise_exception
        #
        # @return [::HTTP::Client]
        #
        # @param [Object] raise_exception
        def build(headers: {}, timeout: nil, raise_exception: true)
          client = raise_exception ? ::HTTP.use(:better_error) : ::HTTP

          headers["User-Agent"] ||= USER_AGENT

          client = client.headers(headers)
          client = client.timeout(timeout) unless timeout.nil?
          client
        end
      end
    end
  end
end
