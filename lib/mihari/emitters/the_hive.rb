# frozen_string_literal: true

require "hachi"
require "net/ping"

module Mihari
  module Emitters
    class TheHive < Base
      # @return [true, false]
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
        @api ||= Hachi::API.new(api_endpoint: Mihari.config.thehive_api_endpoint, api_key: Mihari.config.thehive_api_key)
      end

      # @return [true, false]
      def api_endpont?
        !Mihari.config.thehive_api_endpoint.nil?
      end

      # @return [true, false]
      def api_key?
        !Mihari.config.thehive_api_key.nil?
      end

      def ping?
        base_url = Mihari.config.thehive_api_endpoint
        base_url = base_url.end_with?("/") ? base_url[0..-2] : base_url
        url = "#{base_url}/index.html"

        http = Net::Ping::HTTP.new(url)
        http.ping?
      end
    end
  end
end
