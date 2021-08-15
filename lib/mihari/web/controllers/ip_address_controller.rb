# frozen_string_literal: true

require "http"
require "json"

module Mihari
  module Controllers
    class IPAddressController < BaseController
      def query(ip)
        headers = {}
        token = Mihari.config.ipinfo_api_key
        unless token.nil?
          headers[:authorization] = "Bearer #{token}"
        end

        res = HTTP.headers(headers).get("https://ipinfo.io/#{ip}/json")
        JSON.parse res.to_s
      end

      get "/api/ip_addresses/:ip" do
        param :ip, String, required: true

        ip = params["ip"].to_s

        begin
          data = query(ip)
          json data
        rescue HTTP::Error
          status 404

          json({ message: "IP:#{ip} is not found" })
        end
      end
    end
  end
end
