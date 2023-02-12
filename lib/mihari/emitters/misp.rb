# frozen_string_literal: true

require "misp"

module Mihari
  module Emitters
    class MISP < Base
      # @return [String, nil]
      attr_reader :url

      # @return [String, nil]
      attr_reader :api_key

      def initialize(*args, **kwargs)
        super(*args, **kwargs)

        @url = kwargs[:url] || kwargs[:api_endpoint] || Mihari.config.misp_url
        @api_key = kwargs[:api_key] || Mihari.config.misp_api_key

        ::MISP.configure do |config|
          config.api_endpoint = url
          config.api_key = api_key
        end
      end

      # @return [Boolean]
      def valid?
        unless url? && api_key?
          Mihari.logger.info("MISP URL is not set") unless url?
          Mihari.logger.info("MISP API key is not set") unless api_key?
          return false
        end

        unless ping?
          Mihari.logger.info("MISP URL (#{url}) is not reachable")
          return false
        end

        true
      end

      #
      # Create a MISP event
      #
      # @param [Arra<Mihari::Artifact>] artifacts
      # @param [Mihari::Rule] rule
      # @param [Array<Mihari::Tag>] tags
      #
      # @return [::MISP::Event]
      #
      def emit(rule:, artifacts:, tags: [], **_options)
        return if artifacts.empty?

        event = ::MISP::Event.new(info: rule.title)

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
        %w[misp_url misp_api_key]
      end

      #
      # Build a MISP attribute
      #
      # @param [Mihari::Artifact] artifact
      #
      # @return [::MISP::Attribute]
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
      # Check whether a URL is set or not
      #
      # @return [Boolean]
      #
      def url?
        !url.nil? && !url.empty?
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
      # Check whether a URL is reachable or not
      #
      # @return [Boolean]
      #
      def ping?
        base_url = url.end_with?("/") ? url[0..-2] : url
        login_url = "#{base_url}/users/login"

        http = Net::Ping::HTTP.new(login_url)
        http.ping?
      end
    end
  end
end
