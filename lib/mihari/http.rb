# frozen_string_literal: true

require "insensitive_hash"

module Mihari
  class HTTP
    # @return [String]
    attr_reader :url

    # @return [Hash]
    attr_reader :headers

    def initialize(url, headers: {})
      @url = url.is_a?(URI) ? url : URI(url.to_s)
      @headers = headers.insensitive
    end

    #
    # Make a GET request
    #
    # @param [Hash, nil] params
    #
    # @return [Net::HTTPResponse]
    #
    def get(params: nil)
      new_url = url.deep_dup
      new_url.query = Addressable::URI.form_encode(params) unless (params || {}).empty?

      get = Net::HTTP::Get.new(new_url)
      request get
    end

    #
    # Make a POST requesti
    #
    # @param [Hash, nil] params
    # @param [Hash, nil] json
    # @param [Hash, nil] data
    #
    # @return [Net::HTTPResponse]
    #
    def post(params: nil, json: nil, data: nil)
      new_url = url.deep_dup
      new_url.query = Addressable::URI.form_encode(params) unless (params || {}).empty?

      post = Net::HTTP::Post.new(new_url)

      post.body = JSON.generate(json) if json
      post.set_form_data(data) if data

      request post
    end

    class << self
      def get(url, headers: {}, params: nil)
        client = new(url, headers: headers)
        client.get(params: params)
      end

      def post(url, headers: {}, params: nil, json: nil, data: nil)
        client = new(url, headers: headers)
        client.post(params: params, json: json, data: data)
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
      return { use_ssl: true } if url.scheme == "https"

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
      Net::HTTP.start(url.host, url.port, https_options) do |http|
        # set headers
        headers.each do |k, v|
          req[k] = v
        end

        res = http.request(req)

        unless res.is_a?(Net::HTTPSuccess)
          code = res.code.to_i
          raise UnsuccessfulStatusCodeError, "Unsuccessful response code returned: #{code}"
        end

        res
      end
    rescue Errno::ECONNRESET, Errno::ECONNREFUSED, Errno::EHOSTUNREACH, EOFError, SocketError, Net::ProtocolError => e
      raise NetworkError, e
    rescue Timeout::Error => e
      raise TimeoutError, e
    rescue OpenSSL::SSL::SSLError => e
      raise SSLError, e
    end
  end
end
