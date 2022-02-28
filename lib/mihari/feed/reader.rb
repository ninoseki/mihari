# frozen_string_literal: true

require "csv"

module Mihari
  module Feed
    class Reader
      attr_reader :uri, :http_request_headers, :http_request_method, :http_request_payload_type, :http_request_payload

      def initialize(uri, http_request_headers: {}, http_request_method: "GET", http_request_payload_type: nil, http_request_payload: {})
        @uri = Addressable::URI.parse(uri)
        @http_request_headers = http_request_headers
        @http_request_method = http_request_method
        @http_request_payload_type = http_request_payload_type
        @http_request_payload = http_request_payload
      end

      def read
        return read_file(uri.path) if uri.scheme == "file"

        res = nil
        client = HTTP.new(uri, headers: http_request_headers, payload: http_request_payload, payload_type: http_request_payload_type)

        res = client.get if http_request_method == "GET"
        res = client.post if http_request_method == "POST"

        return [] if res.nil?

        body = res.body
        content_type = res["Content-Type"].to_s
        if content_type.include?("application/json")
          convert_as_json(body)
        else
          convert_as_csv(body)
        end
      end

      #
      # Convert text as JSON
      #
      # @param [String] text
      #
      # @return [Array<Hash>]
      #
      def convert_as_json(text)
        data = JSON.parse(text, symbolize_names: true)
        return data if data.is_a?(Array)

        [data]
      end

      #
      # Convert text as CSV
      #
      # @param [String] text
      #
      # @return [Array<Hash>]
      #
      def convert_as_csv(text)
        text_without_comments = text.lines.reject { |line| line.start_with? "#" }.join("\n")

        CSV.new(text_without_comments).to_a.reject(&:empty?)
      end

      #
      # Read & convert a file
      #
      # @param [String] path
      #
      # @return [Array<Hash>]
      #
      def read_file(path)
        text = File.read(path)

        if path.end_with?(".json")
          convert_as_json text
        else
          convert_as_csv text
        end
      end
    end
  end
end
