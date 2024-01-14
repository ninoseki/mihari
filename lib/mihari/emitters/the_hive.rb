# frozen_string_literal: true

module Mihari
  module Emitters
    class TheHive < Base
      # @return [String, nil]
      attr_reader :url

      # @return [String, nil]
      attr_reader :api_key

      # @return [Array<Mihari::Models::Artifact>]
      attr_accessor :artifacts

      #
      # @param [Mihari::Rule] rule
      # @param [Hash, nil] options
      # @param [Hash] params
      #
      def initialize(rule:, options: nil, **params)
        super(rule: rule, options: options)

        @url = params[:url] || Mihari.config.thehive_url
        @api_key = params[:api_key] || Mihari.config.thehive_api_key

        @artifacts = []
      end

      #
      # @return [Boolean]
      #
      def configured?
        api_key? && url?
      end

      #
      # @return [String]
      #
      def target
        URI(url).host || "N/A"
      end

      #
      # Create a Hive alert
      #
      # @param [Array<Mihari::Models::Artifact>] artifacts
      #
      def call(artifacts)
        return if artifacts.empty?

        @artifacts = artifacts

        client.alert payload
      end

      private

      def client
        Clients::TheHive.new(url, api_key: api_key, api_version: "v1", timeout: timeout)
      end

      #
      # Check whether a URL is set or not
      #
      # @return [Boolean]
      #
      def url?
        !url.nil?
      end

      #
      # Build payload for alert
      #
      # @return [Hash]
      #
      def payload
        {
          title: rule.title,
          description: rule.description,
          observables: artifacts.map do |artifact|
            {
              data: artifact.data,
              data_type: artifact.data_type,
              message: rule.description
            }
          end,
          tags: rule.tags,
          type: "external",
          source: "mihari",
          source_ref: SecureRandom.uuid
        }
      end
    end
  end
end
