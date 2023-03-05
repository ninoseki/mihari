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

      def initialize(*args, **kwargs)
        super(*args, **kwargs)

        url = kwargs[:url]
        headers = kwargs[:headers] || {}
        method = kwargs[:method] || "POST"
        template = kwargs[:template]

        @url = Addressable::URI.parse(url)
        @headers = headers
        @method = method
        @template = template
      end

      def emit(artifacts:, rule:)
        return if artifacts.empty?

        res = nil

        payload_ = payload_as_string(artifacts: artifacts, rule: rule)
        payload = JSON.parse(payload_)

        client = Mihari::HTTP.new(url, headers: headers)

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
