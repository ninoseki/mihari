# frozen_string_literal: true

module Mihari
  module Analyzers
    #
    # Feed analyzer
    #
    class Feed < Base
      # @return [Hash, nil]
      attr_reader :form

      # @return [Hash, nil]
      attr_reader :json

      # @return [Hash, nil]
      attr_reader :params

      # @return [Hash]
      attr_reader :headers

      # @return [String]
      attr_reader :method

      # @return [String]
      attr_reader :selector

      # @return [String]
      attr_reader :query

      #
      # @param [String] query
      # @param [Hash, nil] options
      # @param [String] method
      # @param [Hash, nil] headers
      # @param [Hash, nil] params
      # @param [Hash, nil] json
      # @param [form, nil] form
      # @param [String] selector
      #
      # @param [Object] url
      def initialize(url, options: nil, method: "GET", headers: nil, params: nil, json: nil, form: nil, selector: "")
        super(url, options: options)

        @method = method
        @headers = headers || {}
        @params = params
        @json = json
        @form = form
        @selector = selector
      end

      def artifacts
        data = Services::FeedReader.call(
          url, headers: headers, method: method, params: params, json: json, form: form, timeout: timeout
        )
        Services::FeedParser.call(data, selector)
      end

      private

      def url
        query
      end
    end
  end
end
