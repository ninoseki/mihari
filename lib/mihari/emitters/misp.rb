# frozen_string_literal: true

require "misp"
require "net/ping"

module Mihari
  module Emitters
    class MISP < Base
      def initialize
        super()

        ::MISP.configure do |config|
          config.api_endpoint = Mihari.config.misp_api_endpoint
          config.api_key = Mihari.config.misp_api_key
        end
      end

      # @return [true, false]
      def valid?
        api_endpoint? && api_key? && ping?
      end

      def emit(title:, artifacts:, tags: [], **_options)
        return if artifacts.empty?

        event = ::MISP::Event.new(info: title)

        artifacts.each do |artifact|
          event.attributes << build_attribute(artifact)
        end

        tags.each do |tag|
          event.add_tag name: tag
        end

        event.create
      end

      private

      def configuration_keys
        %w[misp_api_endpoint misp_api_key]
      end

      def build_attribute(artifact)
        ::MISP::Attribute.new(value: artifact.data, type: to_misp_type(type: artifact.data_type, value: artifact.data))
      end

      def hash_type(value)
        case value.length
        when 32
          "md5"
        when 40
          "sha1"
        when 64
          "sha256"
        when 128
          "sha512"
        end
      end

      def to_misp_type(type:, value:)
        type = type.to_sym
        table = {
          ip: "ip-dst",
          mail: "email-dst",
          url: "url",
          domain: "domain"
        }
        return table[type] if table.key?(type)

        hash_type value
      end

      def create_attribute(artifact)
        artifact.data_type
      end

      def api_endpoint?
        api_endpoint = ::MISP.configuration.api_endpoint
        !api_endpoint.nil? && !api_endpoint.empty?
      end

      def api_key?
        api_key = ::MISP.configuration.api_key
        !api_key.nil? && !api_key.empty?
      end

      def ping?
        base_url = ::MISP.configuration.api_endpoint
        base_url = base_url.end_with?("/") ? base_url[0..-2] : base_url
        url = "#{base_url}/users/login"

        http = Net::Ping::HTTP.new(url)
        http.ping?
      end
    end
  end
end
