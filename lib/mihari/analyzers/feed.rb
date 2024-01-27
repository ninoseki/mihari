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
      # @param [String] url
      # @param [Hash, nil] options
      # @param [Hash] params
      #
      def initialize(url, options: nil, **params)
        super(url, options:)

        @method = params[:method] || "GET"
        @headers = params[:headers] || {}
        @params = params[:params]
        @json = params[:json]
        @form = params[:form]
        @selector = params[:selector] || ""
      end

      def artifacts
        data = Services::FeedReader.call(
          url, headers:, method:, params:, json:, form:, timeout:
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
