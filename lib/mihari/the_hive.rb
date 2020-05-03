# frozen_string_literal: true

require "net/ping"
require "uri"

module Mihari
  class TheHive
    attr_reader :artifact
    attr_reader :alert

    def initialize
      @artifact = Artifact.new
      @alert = Alert.new
    end

    # @return [true, false]
    def valid?
      api_endpont? && api_key? && ping?
    end

    private

    # @return [true, false]
    def api_endpont?
      !Mihari.config.thehive_api_endpoint.nil?
    end

    # @return [true, false]
    def api_key?
      !Mihari.config.thehive_api_key.nil?
    end

    def ping?
      base_url = Mihari.config.thehive_api_endpoint
      base_url = base_url.end_with?("/") ? base_url[0..-2] : base_url
      url = "#{base_url}/index.html"

      http = Net::Ping::HTTP.new(url)
      http.ping?
    end
  end
end
