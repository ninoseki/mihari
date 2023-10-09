# frozen_string_literal: true

require "http"

module Mihari
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
        client = ::HTTP::Client.new.headers(headers)
        client = client.timeout(timeout) unless timeout.nil?

        handle_request client, :get, uri, params: params
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
        client = ::HTTP::Client.new.headers(headers)
        client = client.timeout(timeout) unless timeout.nil?

        handle_request client, :post, uri, params: params, json: json, form: data
      end

      private

      #
      # Make a HTTP request
      #
      # @param [Net::HTTPRequest] req
      #
      # @return [::HTTP::Response]
      #
      def handle_request(client, method, uri, options = {})
        res = client.request(method, uri, options)
        unless res.status.success?
          raise StatusCodeError.new(
            "Unsuccessful response code returned: #{res.code}",
            res.code,
            res.body.to_s
          )
        end
        res
      rescue ::HTTP::TimeoutError => e
        raise TimeoutError, e
      rescue ::HTTP::Error => e
        raise NetworkError, e
      rescue OpenSSL::SSL::SSLError => e
        raise SSLError, e
      end
    end
  end
end
