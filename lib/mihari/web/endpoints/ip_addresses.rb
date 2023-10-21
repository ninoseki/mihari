# frozen_string_literal: true

module Mihari
  module Endpoints
    class IPAddresses < Grape::API
      namespace :ip_addresses do
        desc "Get an IP address", {
          success: Entities::IPAddress,
          failure: [{ code: 404, message: "Not found", model: Entities::Message }],
          summary: "Get an IP address"
        }
        params do
          requires :ip, type: String, regexp: /\A[0-9.]+\z/
        end
        get "/:ip", requirements: { ip: %r{[^/]+} } do
          ip = params[:ip].to_s

          data = Enrichers::IPInfo.new.query(ip)
          error!({ message: "IP:#{ip} is not found" }, 404) if data.nil?

          present data, with: Entities::IPAddress
        end
      end
    end
  end
end
