# frozen_string_literal: true

module Mihari
  module Web
    module Endpoints
      #
      # IP address API endpoint
      #
      class IPAddresses < Grape::API
        namespace :ip_addresses do
          desc "Get IP address data", {
            success: Entities::IPAddress,
            failure: [
              {code: 404, model: Entities::ErrorMessage},
              {code: 422, model: Entities::ErrorMessage}
            ],
            summary: "Get IP address data"
          }
          params do
            requires :ip, type: String
          end
          get "/:ip", requirements: {ip: %r{[^/]+}} do
            ip = params[:ip].to_s
            result = Services::IPGetter.get_result(ip)
            if result.success?
              value = result.value!
              return present(
                {
                  country_code: value.country_code,
                  asn: value.asn,
                  loc: value.loc
                },
                with: Entities::IPAddress
              )
            end

            failure = result.failure
            case failure
            when Mihari::StatusError
              error!({message: "IP:#{ip} not found"}, failure.status_code) if failure.status_code == 404
              error!({message: "IP format invalid"}, failure.status_code) if failure.status_code == 422
            end
            raise failure
          end
        end
      end
    end
  end
end
