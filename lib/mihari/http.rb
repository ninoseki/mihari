# frozen_string_literal: true

require "insensitive_hash"

module Mihari
  class HTTP
    attr_reader :uri, :headers, :payload

    def initialize(uri, headers: {}, payload: {})
      @uri = uri.is_a?(URI) ? uri : URI(uri.to_s)
      @headers = headers.insensitive
      @payload = payload
    end

    #
    # Make a GET request
    #
    # @return [Net::HTTPResponse]
    #
    def get
      new_uri = uri.deep_dup
      new_uri.query = Addressable::URI.form_encode(payload) unless payload.empty?

      get = Net::HTTP::Get.new(new_uri)
      request get
    end

    #
    # Make a POST request
    #
    # @return [Net::HTTPResponse]
    #
    def post
      post = Net::HTTP::Post.new(uri)

      case content_type
      when "application/json"
        post.body = JSON.generate(payload)
      when "application/x-www-form-urlencoded"
        post.set_form_data(payload)
      end

      request post
    end

    class << self
      def get(uri, headers: {}, payload: {})
        client = new(uri, headers: headers, payload: payload)
        client.get
      end

      def post(uri, headers: {}, payload: {})
        client = new(uri, headers: headers, payload: payload)
        client.post
      end
    end

    private

    def content_type
      headers["content-type"] || "application/json"
    end

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

        unless res.is_a?(Net::HTTPSuccess)
          code = res.code.to_i
          raise HttpError, "Unsuccessful response code returned: #{code}"
        end

        res
      end
    end
  end
end
