# frozen_string_literal: true

require "insensitive_hash"

module Mihari
  class HTTP
    attr_reader :url, :headers, :payload

    def initialize(url, headers: {}, payload: {})
      @url = url.is_a?(URI) ? url : URI(url.to_s)
      @headers = headers.insensitive
      @payload = payload
    end

    #
    # Make a GET request
    #
    # @return [Net::HTTPResponse]
    #
    def get
      new_url = url.deep_dup
      new_url.query = Addressable::URI.form_encode(payload) unless payload.empty?

      get = Net::HTTP::Get.new(new_url)
      request get
    end

    #
    # Make a POST request
    #
    # @return [Net::HTTPResponse]
    #
    def post
      post = Net::HTTP::Post.new(url)

      case content_type
      when "application/json"
        post.body = JSON.generate(payload)
      when "application/x-www-form-urlencoded"
        post.set_form_data(payload)
      end

      request post
    end

    class << self
      def get(url, headers: {}, params: {})
        client = new(url, headers: headers, payload: params)
        client.get
      end

      def post(url, headers: {}, payload: {})
        client = new(url, headers: headers, payload: payload)
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
