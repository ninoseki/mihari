# frozen_string_literal: true

require "erb"

module Mihari
  module Emitters
    class PayloadTemplate < ERB
      def self.template
        %{
					{
						"title": "<%= @title %>",
						"description": "<%= @description %>",
						"source": "<%= @source %>",
						"artifacts": [
							<% @artifacts.each_with_index do |artifact, idx| %>
								"<%= artifact.data %>"
								<%= ',' if idx < (@artifacts.length - 1) %>
							<% end %>
						],
						"tags": [
							<% @tags.each_with_index do |tag, idx| %>
								"<%= tag %>"
								<%= ',' if idx < (@tags.length - 1) %>
							<% end %>
						]
					}
				}
      end

      def initialize(title:, description:, artifacts:, source:, tags:, options: {})
        @title = title
        @description = description
        @artifacts = artifacts
        @source = source
        @tags = tags

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

      def emit(title:, description:, artifacts:, source:, tags:)
        return if artifacts.empty?

        res = nil

        payload_ = payload_as_string(
          title: title,
          description: description,
          artifacts: artifacts,
          source: source,
          tags: tags
        )
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

        ["http", "https"].include? uri.scheme.downcase
      end

      private

      def payload_as_string(title:, description:, artifacts:, source:, tags:)
        @payload_as_string ||= [].tap do |out|
          options = {}
          unless template.nil?
            options[:template] = File.read(template)
          end

          payload_template = PayloadTemplate.new(
            title: title,
            description: description,
            artifacts: artifacts,
            source: source,
            tags: tags,
            options: options
          )
          out << payload_template.result
        end.first
      end
    end
  end
end
