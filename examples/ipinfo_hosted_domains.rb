# frozen_string_literal: true

$LOAD_PATH.unshift("#{__dir__}/../lib")

require "json"
require "mihari"
require "open-uri"

module Mihari
  module Analyzers
    class HostedDomains < Base
      attr_reader :ip

      IPINFO_API_ENDPOINT = "https://ipinfo.io"

      def initialize(ip, token: nil)
        @ip = ip
        @token = token
      end

      def title
        "IPinfo hosted domains"
      end

      def description
        "IP info hosted domains: #{ip}"
      end

      def token
        ENV["IPINFO_TOKEN"] || @token
      end

      def artifacts
        uri = URI("#{IPINFO_API_ENDPOINT}/domains/#{ip}?token=#{token}")
        res = uri.read
        json = JSON.parse(res)
        json.dig("domains") || []
      end
    end
  end
end

ip = "TARGET_IP"
analyzer = Mihari::Analyzers::HostedDomains.new(ip)
analyzer.run
