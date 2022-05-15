# frozen_string_literal: true

require "hachi"

module Mihari
  module Emitters
    class TheHive < Base
      # @return [String, nil]
      attr_reader :api_endpoint

      # @return [String, nil]
      attr_reader :api_key

      # @return [String, nil]
      attr_reader :api_version

      def initialize(*args, **kwargs)
        super(*args, **kwargs)

        @api_endpoint = kwargs[:api_endpoint] || Mihari.config.thehive_api_endpoint
        @api_key = kwargs[:api_key] || Mihari.config.thehive_api_key
        @api_version = kwargs[:api_version] || Mihari.config.thehive_api_version
      end

      # @return [Boolean]
      def valid?
        api_endpont? && api_key? && ping?
      end

      def emit(title:, description:, artifacts:, tags: [], **_options)
        return if artifacts.empty?

        payload = payload(title: title, description: description, artifacts: artifacts, tags: tags)
        api.alert.create(**payload)
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
          table = {
            "" => nil,
            "v4" => nil,
            "v5" => "v1"
          }
          out << table[api_version.downcase]
        end.first
      end

      private

      def configuration_keys
        %w[thehive_api_endpoint thehive_api_key]
      end

      def api
        @api ||= Hachi::API.new(api_endpoint: api_endpoint, api_key: api_key, api_version: normalized_api_version)
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

      def payload(title:, description:, artifacts:, tags: [])
        return v4_payload(title: title, description: description, artifacts: artifacts, tags: tags) if normalized_api_version.nil?

        v5_payload(title: title, description: description, artifacts: artifacts, tags: tags)
      end

      def v4_payload(title:, description:, artifacts:, tags: [])
        {
          title: title,
          description: description,
          artifacts: artifacts.map { |artifact| { data: artifact.data, data_type: artifact.data_type, message: description } },
          tags: tags,
          type: "external",
          source: "mihari"
        }
      end

      def v5_payload(title:, description:, artifacts:, tags: [])
        {
          title: title,
          description: description,
          observables: artifacts.map { |artifact| { data: artifact.data, data_type: artifact.data_type, message: description } },
          tags: tags,
          type: "external",
          source: "mihari",
          source_ref: "1"
        }
      end

      #
      # Check whether an API endpoint is reachable or not
      #
      # @return [Boolean]
      #
      def ping?
        base_url = api_endpoint.end_with?("/") ? api_endpoint[0..-2] : api_endpoint

        if normalized_api_version.nil?
          # for v4
          base_url = api_endpoint.end_with?("/") ? api_endpoint[0..-2] : api_endpoint
          url = "#{base_url}/index.html"
        else
          # for v5
          url = "#{base_url}/api/v1/status/public"
        end

        http = Net::Ping::HTTP.new(url)

        # use GET for v5
        http.get_request = true if normalized_api_version

        http.ping?
      end
    end
  end
end
