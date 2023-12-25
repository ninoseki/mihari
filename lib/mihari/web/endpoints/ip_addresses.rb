# frozen_string_literal: true

module Mihari
  module Web
    module Endpoints
      #
      # IP address API endpoint
      #
      class IPAddresses < Grape::API
        namespace :ip_addresses do
          desc "Get an IP address", {
            success: Entities::IPAddress,
            failure: [{ code: 404, model: Entities::ErrorMessage }],
            summary: "Get an IP address"
          }
          params do
            requires :ip, type: String, regexp: /\A[0-9.]+\z/
          end
          get "/:ip", requirements: { ip: %r{[^/]+} } do
            ip = params[:ip].to_s
            result = Services::IPGetter.result(ip)
            return present(result.value!, with: Entities::IPAddress) if result.success?

            failure = result.failure
            case failure
            when Mihari::StatusCodeError
              error!({ message: "ID:#{id} not found" }, 404) if failure.status_code == 404
            end
            raise failure
          end
        end
      end
    end
  end
end
