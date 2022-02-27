# frozen_string_literal: true

module Mihari
  class HTTP
    attr_reader :uri, :headers, :payload_type, :payload

    def initialize(uri, headers: {}, payload_type: nil, payload: {})
      @uri = Addressable::URI.parse(uri)
      @headers = headers
      @payload_type = payload_type
      @payload = payload
    end

    #
    # Make a GET request
    #
    # @return [Net::HTTPResponse]
    #
    def get
      uri.query = Addressable::URI.form_encode(payload)
      get = Net::HTTP::Get.new(uri)

      request(get)
    end

    #
    # Make a POST request
    #
    # @return [Net::HTTPResponse]
    #
    def post
      post = Net::HTTP::Post.new(uri)

      case payload_type
      when "application/json"
        headers["content-type"] = "application/json" unless headers.key?("content-type")
        post.body = JSON.generate(payload)
      when "application/x-www-form-urlencoded"
        headers["content-type"] = "application/x-www-form-urlencoded" unless headers.key?("content-type")
        post.set_form_data(payload)
      end

      request(post)
    end

    class << self
      def get(uri, headers: {}, payload_type: nil, payload: {})
        client = new(uri, headers: headers, payload_type: payload_type, payload: payload)
        client.get
      end

      def post(uri, headers: {}, payload_type: nil, payload: {})
        client = new(uri, headers: headers, payload_type: payload_type, payload: payload)
        client.post
      end
    end

    private

    #
    # Get options for HTTP request
    #
    # @return [Hahs]
    #
    def https_options
      return { use_ssl: true } if uri.scheme == "https"

      {}
    end

    #
    # Make a HTTP request
    #
    # @param [Net::HTTPRequest] req
    #
    # @return [Net::HTTPResponse]
    #
    def request(req)
      Net::HTTP.start(uri.host, uri.port, https_options) do |http|
        # set headers
        headers.each do |k, v|
          req[k] = v
        end

        res = http.request(req)

        code = res.code.to_i
        raise HttpError, "Unsupported response code returned: #{code}" if code != 200

        res
      end
    end
  end
end
