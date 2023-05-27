# frozen_string_literal: true

require "csv"
require "insensitive_hash"

module Mihari
  module Feed
    class Reader
      # @return [String]
      attr_reader :url

      # @return [Hash]
      attr_reader :headers

      # @return [Hash, nil]
      attr_reader :params

      # @return [Hash, nil]
      attr_reader :json

      # @return [Hash, nil]
      attr_reader :data

      # @return [String]
      attr_reader :method

      def initialize(url, headers: {}, method: "GET", params: nil, json: nil, data: nil)
        @url = Addressable::URI.parse(url)
        @headers = headers.insensitive
        @method = method

        @params = params
        @json = json
        @data = data

        headers["content-type"] = "application/json" unless json.nil?
      end

      #
      # @return [Array<Hash>]
      #
      def read
        return read_file(url.path) if url.scheme == "file"

        res = nil
        client = HTTP.new(url, headers: headers)

        res = client.get(params: params) if method == "GET"
        res = client.post(params: params, json: json, data: data) if method == "POST"

        return [] if res.nil?

        body = res.body
        content_type = res["Content-Type"].to_s
        return convert_as_json(body) if content_type.include?("application/json")

        convert_as_csv(body)
      end

      #
      # Convert text as JSON
      #
      # @param [String] text
      #
      # @return [Array<Hash>]
      #
      def convert_as_json(text)
        parsed = JSON.parse(text, symbolize_names: true)
        return parsed if parsed.is_a?(Array)

        [parsed]
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

        return convert_as_json(text) if path.end_with?(".json")

        convert_as_csv text
      end
    end
  end
end
