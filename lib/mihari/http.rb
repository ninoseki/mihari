# frozen_string_literal: true

require "http"

module Mihari
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

  class HTTP
    class << self
      #
      # Make a GET request
      #
      # @param [String, URI] uri
      # @param [Integer, nil] timeout
      # @param [Hash] headers
      # @param [Hash, nil] params
      #
      # @return [Net::HTTPResponse]
      #
      def get(uri, headers: {}, timeout: nil, params: nil)
        client = ::HTTP.use(:better_error).headers(headers)
        client = client.timeout(timeout) unless timeout.nil?
        client.get uri, params: params
      end

      #
      # Make a POST request
      #
      # @param [String, URI] uri
      # @param [Hash] headers
      # @param [Integer, nil] timeout
      # @param [Hash, nil] params
      # @param [Hash, nil] json
      # @param [Hash, nil] data
      #
      # @return [Net::HTTPResponse]
      #
      def post(uri, headers: {}, timeout: nil, params: nil, json: nil, data: nil)
        client = ::HTTP.use(:better_error).headers(headers)
        client = client.timeout(timeout) unless timeout.nil?
        client.post uri, params: params, json: json, form: data
      end
    end
  end
end
