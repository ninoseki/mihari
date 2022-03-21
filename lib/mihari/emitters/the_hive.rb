# frozen_string_literal: true

require "hachi"

module Mihari
  module Emitters
    class TheHive < Base
      # @return [String, nil]
      attr_reader :api_endpoint

      # @return [String, nil]
      attr_reader :api_key

      def initialize(*args, **kwargs)
        super(*args, **kwargs)

        @api_endpoint = kwargs[:api_endpoint] || Mihari.config.thehive_api_endpoint
        @api_key = kwargs[:api_key] || Mihari.config.thehive_api_key
      end

      # @return [Boolean]
      def valid?
        api_endpont? && api_key? && ping?
      end

      def emit(title:, description:, artifacts:, tags: [], **_options)
        return if artifacts.empty?

        api.alert.create(
          title: title,
          description: description,
          artifacts: artifacts.map { |artifact| { data: artifact.data, data_type: artifact.data_type, message: description } },
          tags: tags,
          type: "external",
          source: "mihari"
        )
      end

      private

      def configuration_keys
        %w[thehive_api_endpoint thehive_api_key]
      end

      def api
        @api ||= Hachi::API.new(api_endpoint: api_endpoint, api_key: api_key)
      end

      #
      # Check whether an API endpoint is set or not
      #
      # @return [Boolean]
      #
      def api_endpont?
        !api_endpoint.nil?
      end

      #
      # Check whether an API key is set or not
      #
      # @return [Boolean]
      #
      def api_key?
        !api_key.nil?
      end

      #
      # Check whether an API endpoint is reachable or not
      #
      # @return [Boolean]
      #
      def ping?
        base_url = api_endpoint.end_with?("/") ? api_endpoint[0..-2] : api_endpoint
        url = "#{base_url}/index.html"

        http = Net::Ping::HTTP.new(url)
        http.ping?
      end
    end
  end
end
