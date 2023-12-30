# frozen_string_literal: true

module Mihari
  module Emitters
    class TheHive < Base
      # @return [String, nil]
      attr_reader :url

      # @return [String, nil]
      attr_reader :api_key

      # @return [String, nil]
      attr_reader :api_version

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
        @api_version = params[:api_version] || Mihari.config.thehive_api_version

        @artifacts = []
      end

      #
      # @return [Boolean]
      #
      def configured?
        api_key? && url?
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

      #
      # Normalize API version for API client
      #
      # @param [String] version
      #
      # @return [String, nil]
      #
      def normalized_api_version
        @normalized_api_version ||= [].tap do |out|
          # v4 does not have version prefix in path (/api/)
          # v5 has version prefix in path (/api/v1/)
          table = { "" => nil, "v4" => nil, "v5" => "v1" }
          out << table[api_version.to_s.downcase]
        end.first
      end

      class << self
        def configuration_keys
          %w[thehive_url thehive_api_key]
        end
      end

      private

      def client
        @client ||= Clients::TheHive.new(url, api_key: api_key, api_version: normalized_api_version, timeout: timeout)
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
        return v4_payload if normalized_api_version.nil?

        v5_payload
      end

      def v4_payload
        {
          title: rule.title,
          description: rule.description,
          artifacts: artifacts.map do |artifact|
            {
              data: artifact.data,
              data_type: artifact.data_type,
              message: rule.description
            }
          end,
          tags: rule.tags,
          type: "external",
          source: "mihari"
        }
      end

      def v5_payload
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
          source_ref: "1"
        }
      end
    end
  end
end
