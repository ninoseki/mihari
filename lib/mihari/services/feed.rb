require "csv"

require "jr/cli/core_ext"

module Mihari
  module Services
    #
    # Feed reader
    #
    class FeedReader < Service
      #
      # @param [String] url
      # @param [Hash, nil] options
      # @param [String] method
      # @param [Hash, nil] headers
      # @param [Hash, nil] params
      # @param [Hash, nil] json
      # @param [form, nil] form
      # @param [String] selector
      # @param [Integer, nil] timeout
      #
      # @return [Array<Hash>]
      #
      def call(url, headers: {}, method: "GET", params: nil, json: nil, form: nil, timeout: nil)
        url = Addressable::URI.parse(url)

        return read_file(url.path) if url.scheme == "file"

        http = HTTP::Factory.build(headers: headers, timeout: timeout)

        res = http.get(url, params: params) if method == "GET"
        res = http.post(url, params: params, json: json, form: form) if method == "POST"

        body = res.body.to_s
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

    #
    # Feed parser
    #
    class FeedParser < Service
      #
      # Parse data by selector
      #
      # @param [Array<Hash>, Array<Array<String>>] data
      # @param [String] selector
      #
      # @return [Array<String>]
      #
      def call(data, selector)
        parsed = data.instance_eval(selector)

        raise TypeError unless parsed.is_a?(Array) || parsed.is_a?(Enumerator)
        raise TypeError unless parsed.all?(String)

        parsed.to_a
      end
    end
  end
end
