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

    class Webhook < Base
      # @return [Addressable::URI, nil]
      attr_reader :url

      # @return [Hash]
      attr_reader :headers

      # @return [String]
      attr_reader :method

      # @return [String, nil]
      attr_reader :template

      #
      # @param [Array<Mihari::Artifact>] artifacts
      # @param [Mihari::Services::Rule] rule
      # @param [Hash] **options
      #
      def initialize(artifacts:, rule:, **options)
        super(artifacts: artifacts, rule: rule, **options)

        @url = Addressable::URI.parse(options[:url])
        @headers = options[:headers] || {}
        @method = options[:method] || "POST"
        @template = options[:template]
      end

      def emit
        return if artifacts.empty?

        # returns body to prevent Parallel issue (Parallel fails to handle HTTP:Response object)
        case method
        when "GET"
          http.get(url).body.to_s
        when "POST"
          http.post(url, json: json).body.to_s
        end
      end

      def valid?
        return false if url.nil?

        %w[http https].include? url.scheme.downcase
      end

      private

      def http
        HTTP::Factory.build headers: headers
      end

      #
      # Render template
      #
      # @return [String]
      #
      def rendered_template
        [].tap do |out|
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

      #
      # @return [Hash]
      #
      def json
        JSON.parse rendered_template
      end
    end
  end
end
