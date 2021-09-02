# frozen_string_literal: true

module Mihari
  module Controllers
    class IPAddressController < BaseController
      get "/api/ip_addresses/:ip" do
        param :ip, String, required: true

        ip = params["ip"].to_s

        data = Enrichers::IPInfo.query(ip)
        if data.nil?
          status 404
          json({ message: "IP:#{ip} is not found" })
        else
          json data.to_hash
        end
      end
    end
  end
end
