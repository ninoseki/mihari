# frozen_string_literal: true

module Mihari
  module Emitters
    class MISP < Base
      # @return [String, nil]
      attr_reader :url

      # @return [String, nil]
      attr_reader :api_key

      # @return [Array<Mihari::Artifact>]
      attr_reader :artifacts

      # @return [Mihari::Structs::Rule]
      attr_reader :rule

      def initialize(artifacts:, rule:, **options)
        super(artifacts: artifacts, rule: rule, **options)

        @url = options[:url] || Mihari.config.misp_url
        @api_key = options[:api_key] || Mihari.config.misp_api_key
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
      # @param [Mihari::Structs::Rule] rule
      #
      # @return [::MISP::Event]
      #
      def emit
        return if artifacts.empty?

        client.create_event({
          Event: {
            info: rule.title,
            Attribute: artifacts.map { |artifact| build_attribute(artifact) },
            Tag: rule.tags.map { |tag| { name: tag } }
          }
        })
      end

      private

      def configuration_keys
        %w[misp_url misp_api_key]
      end

      def client
        @client ||= Clients::MISP.new(url, api_key: api_key)
      end

      #
      # Build a MISP attribute
      #
      # @param [Mihari::Artifact] artifact
      #
      # @return [Hash]
      #
      def build_attribute(artifact)
        { value: artifact.data, type: to_misp_type(type: artifact.data_type, value: artifact.data) }
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
