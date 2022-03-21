# frozen_string_literal: true

require "misp"

module Mihari
  module Emitters
    class MISP < Base
      # @return [String, nil]
      attr_reader :api_endpoint

      # @return [String, nil]
      attr_reader :api_key

      def initialize(*args, **kwargs)
        super(*args, **kwargs)

        @api_endpoint = kwargs[:api_endpoint] || Mihari.config.misp_api_endpoint
        @api_key = kwargs[:api_key] || Mihari.config.misp_api_key

        ::MISP.configure do |config|
          config.api_endpoint = api_endpoint
          config.api_key = api_key
        end
      end

      # @return [Boolean]
      def valid?
        api_endpoint? && api_key? && ping?
      end

      def emit(title:, artifacts:, tags: [], **_options)
        return if artifacts.empty?

        p api_endpoint
        p api_key

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

      #
      # Build a MISP attribute
      #
      # @param [Mihari::Artifact] artifact
      #
      # @return [::MISP::Attribute] <description>
      #
      def build_attribute(artifact)
        ::MISP::Attribute.new(value: artifact.data, type: to_misp_type(type: artifact.data_type, value: artifact.data))
      end

      #
      # Get a type of a hash
      #
      # @param [String] value
      #
      # @return [String]
      #
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

      #
      # Convert a type to a MISP type
      #
      # @param [String] type
      # @param [String] value
      #
      # @return [String]
      #
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

      #
      # Check whether an API endpoint is set or not
      #
      # @return [Boolean]
      #
      def api_endpoint?
        !api_endpoint.nil? && !api_endpoint.empty?
      end

      #
      # Check whether an API key is set or not
      #
      # @return [Boolean]
      #
      def api_key?
        !api_key.nil? && !api_key.empty?
      end

      #
      # Check whether an API endpoint is reachable or not
      #
      # @return [Boolean]
      #
      def ping?
        base_url = api_endpoint.end_with?("/") ? api_endpoint[0..-2] : api_endpoint
        url = "#{base_url}/users/login"

        http = Net::Ping::HTTP.new(url)
        http.ping?
      end
    end
  end
end
