# frozen_string_literal: true

require "csv"
require "json"
require "net/https"
require "uri"

module Mihari
  module Feed
    class Reader
      attr_reader :uri, :http_request_headers, :http_request_method, :http_request_payload_type, :http_request_payload

      def initialize(uri, http_request_headers: {}, http_request_method: "GET", http_request_payload_type: nil, http_request_payload: {})
        @uri = URI(uri)
        @http_request_headers = http_request_headers
        @http_request_method = http_request_method
        @http_request_payload_type = http_request_payload_type
        @http_request_payload = http_request_payload
      end

      def read
        return read_file(uri.path) if uri.scheme == "file"

        return get if http_request_method == "GET"

        post
      end

      def get
        uri.query = URI.encode_www_form(http_request_payload)
        get = Net::HTTP::Get.new(uri)

        request(get)
      end

      def post
        post = Net::HTTP::Post.new(uri)

        case http_request_payload_type
        when "application/json"
          post.body = JSON.generate(http_request_payload)
        when "application/x-www-form-urlencoded"
          post.set_form_data(http_request_payload)
        end

        request(post)
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

      def https_options
        return { use_ssl: true } if uri.scheme == "https"

        {}
      end

      #
      # Make a HTTP request
      #
      # @param [Net::HTTPRequest] req
      #
      # @return [Array<Hash>]
      #
      def request(req)
        Net::HTTP.start(uri.host, uri.port, https_options) do |http|
          # set headers
          http_request_headers.each do |k, v|
            req[k] = v
          end

          response = http.request(req)

          code = response.code.to_i
          raise HttpError, "Unsupported response code returned: #{code}" if code != 200

          body = response.body

          content_type = response["Content-Type"].to_s
          if content_type.include?("application/json")
            convert_as_json(body)
          else
            convert_as_csv(body)
          end
        end
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
