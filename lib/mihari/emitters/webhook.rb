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

        client = Mihari::HTTP.new(url, headers: headers)

        res = nil
        case method
        when "GET"
          res = client.get
        when "POST"
          res = client.post(json: payload)
        end

        res
      end

      def valid?
        return false if url.nil?

        %w[http https].include? url.scheme.downcase
      end

      private

      #
      # Convert payload into string
      #
      # @return [String]
      #
      def payload_as_string
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
      def payload
        JSON.parse payload_as_string
      end
    end
  end
end
