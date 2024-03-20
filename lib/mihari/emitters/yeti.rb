# frozen_string_literal: true

module Mihari
  module Emitters
    class Yeti < Base
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
        super(rule:, options:)

        @url = params[:url] || Mihari.config.yeti_url
        @api_key = params[:api_key] || Mihari.config.yeti_api_key

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

        client.create_observables({observables:})
      end

      #
      # @return [String]
      #
      def target
        URI(url).host || "N/A"
      end

      private

      def client
        Clients::Yeti.new(url, api_key:, timeout:)
      end

      #
      # Check whether a URL is set or not
      #
      # @return [Boolean]
      #
      def url?
        !url.nil?
      end

      def acceptable_artifacts
        artifacts.reject { |artifact| artifact.data_type == "mail" }
      end

      #
      # @param [Mihari::Models::Artifact] artifact
      #
      # @return [Hash]
      #
      def artifact_to_observable(artifact)
        convert_table = {
          domain: "hostname",
          ip: "ipv4"
        }

        type = lambda do
          detailed_type = DataType.detailed_type(artifact.data)
          convert_table[detailed_type.to_sym] || detailed_type || artifact.data_type
        end.call

        {
          tags:,
          type:,
          value: artifact.data
        }
      end

      def tags
        @tags ||= rule.tags.map(&:name)
      end

      def observables
        acceptable_artifacts.map { |artifact| artifact_to_observable(artifact) }
      end
    end
  end
end
