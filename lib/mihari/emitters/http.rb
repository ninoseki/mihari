# frozen_string_literal: true

require "erb"

module Mihari
  module Emitters
    class PayloadTemplate < ERB
      def self.template
        %{
					{
						"rule": {
              "id": "<%= @rule.id %>",
              "title": "<%= @rule.title %>",
              "description": "<%= @rule.description %>"
            },
						"artifacts": [
							<% @artifacts.each_with_index do |artifact, idx| %>
								"<%= artifact.data %>"
								<%= ',' if idx < (@artifacts.length - 1) %>
							<% end %>
						],
						"tags": [
							<% @rule.tags.each_with_index do |tag, idx| %>
								"<%= tag %>"
								<%= ',' if idx < (@rule.tags.length - 1) %>
							<% end %>
						]
					}
				}
      end

      def initialize(artifacts:, rule:, options: {})
        @artifacts = artifacts
        @rule = rule

        @template = options.fetch(:template, self.class.template)
        super(@template)
      end

      def result
        super(binding)
      end
    end

    class HTTP < Base
      # @return [Addressable::URI, nil]
      attr_reader :uri

      # @return [Hash]
      attr_reader :http_request_headers

      # @return [String]
      attr_reader :http_request_method

      # @return [String, nil]
      attr_reader :template

      def initialize(*args, **kwargs)
        super(*args, **kwargs)

        uri = kwargs[:url] || kwargs[:uri]
        http_request_headers = kwargs[:http_request_headers] || {}
        http_request_method = kwargs[:http_request_method] || "POST"
        template = kwargs[:template]

        @uri = Addressable::URI.parse(uri) if uri
        @http_request_headers = http_request_headers
        @http_request_method = http_request_method
        @template = template
      end

      def emit(artifacts:, rule:)
        return if artifacts.empty?

        res = nil

        payload_ = payload_as_string(artifacts: artifacts, rule: rule)
        payload = JSON.parse(payload_)

        client = Mihari::HTTP.new(uri, headers: http_request_headers, payload: payload)

        case http_request_method
        when "GET"
          res = client.get
        when "POST"
          res = client.post
        end

        res
      end

      def valid?
        return false if uri.nil?

        %w[http https].include? uri.scheme.downcase
      end

      private

      #
      # Convert payload into string
      #
      # @param [Array<Mihari::Artifact>] artifacts
      # @param [Mihari::Structs::Rule] rule
      #
      # @return [String]
      #
      def payload_as_string(artifacts:, rule:)
        @payload_as_string ||= [].tap do |out|
          options = {}
          options[:template] = File.read(template) unless template.nil?

          payload_template = PayloadTemplate.new(
            artifacts: artifacts,
            rule: rule,
            options: options
          )
          out << payload_template.result
        end.first
      end
    end
  end
end
