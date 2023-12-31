require "csv"

require "jq"

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
      # @return [Hash, Array<Object>]
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
      # @return [Hash, Array<Hash>]
      #
      def convert_as_json(text)
        JSON.parse(text, symbolize_names: true)
      end

      #
      # Convert text as CSV
      #
      # @param [String] text
      #
      # @return [Array<Object>]
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
      # @param [Hash, Array<Object>] data
      # @param [String] selector
      #
      # @return [Array<String>]
      #
      def call(data, selector)
        jq = JQ(data.to_json)
        results = jq.search(selector)

        raise TypeError unless results.all?(String)

        results
      end
    end
  end
end
