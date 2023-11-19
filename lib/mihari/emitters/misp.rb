# frozen_string_literal: true

module Mihari
  module Emitters
    #
    # MISP emitter
    #
    class MISP < Base
      # @return [String, nil]
      attr_reader :url

      # @return [String, nil]
      attr_reader :api_key

      # @return [Mihari::Rule]
      attr_reader :rule

      # @return [Array<Mihari::Models::Artifact>]
      attr_accessor :artifacts

      #
      # @param [Mihari::Rule] rule
      # @param [Hash, nil] options
      # @param [Hash, nil] params
      #
      def initialize(rule:, options: nil, **params)
        super(rule: rule, options: options)

        @url = params[:url] || Mihari.config.misp_url
        @api_key = params[:api_key] || Mihari.config.misp_api_key

        @artifacts = []
      end

      #
      # @return [Boolean]
      #
      def configured?
        api_key? && url?
      end

      #
      # Create a MISP event
      #
      # @param [Array<Mihari::Models::Artifact>] artifacts
      #
      def call(artifacts)
        return if artifacts.empty?

        client.create_event({
          Event: {
            info: rule.title,
            Attribute: artifacts.map { |artifact| build_attribute(artifact) },
            Tag: rule.tags.map { |tag| { name: tag } }
          }
        })
      end

      def configuration_keys
        %w[misp_url misp_api_key]
      end

      private

      def client
        @client ||= Clients::MISP.new(url, api_key: api_key, timeout: timeout)
      end

      #
      # Build a MISP attribute
      #
      # @param [Mihari::Models::Artifact] artifact
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
    end
  end
end
