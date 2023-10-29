# frozen_string_literal: true

module Mihari
  module Clients
    #
    # Base class for API clients
    #
    class Base
      # @return [String]
      attr_reader :base_url

      # @return [Hash]
      attr_reader :headers

      # @return [Integer]
      attr_reader :pagination_interval

      # @return [Integer, nil]
      attr_reader :timeout

      #
      # @param [String] base_url
      # @param [Hash] headers
      # @param [Integer] pagination_interval
      # @param [Integer, nil] timeout
      #
      def initialize(base_url, headers: {}, pagination_interval: Mihari.config.pagination_interval, timeout: nil)
        @base_url = base_url
        @headers = headers || {}
        @pagination_interval = pagination_interval
        @timeout = timeout
      end

      private

      def sleep_pagination_interval
        sleep pagination_interval
      end

      #
      # @return [::HTTP::Client]
      #
      def http
        HTTP::Factory.build headers: headers, timeout: timeout
      end

      #
      # @param [String] path
      #
      # @return [String]
      #
      def url_for(path)
        base_url + path
      end

      #
      # @param [String] path
      # @param [Hash, nil] params
      #
      # @return [::HTTP::Response]
      #
      def get(path, params: nil)
        http.get(url_for(path), params: params)
      end

      #
      # @param [String] path
      # @param [Hash, nil] json
      #
      # @return [::HTTP::Response]
      #
      def post(path, json: {})
        http.post(url_for(path), json: json)
      end
    end
  end
end
