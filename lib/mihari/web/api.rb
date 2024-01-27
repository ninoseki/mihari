# frozen_string_literal: true

# Endpoints
require "mihari/web/endpoints/alerts"
require "mihari/web/endpoints/artifacts"
require "mihari/web/endpoints/configs"
require "mihari/web/endpoints/ip_addresses"
require "mihari/web/endpoints/rules"
require "mihari/web/endpoints/tags"

module Mihari
  module Web
    #
    # Grape API
    #
    class API < Grape::API
      prefix "api"
      format :json

      mount Endpoints::Alerts
      mount Endpoints::Artifacts
      mount Endpoints::Configs
      mount Endpoints::IPAddresses
      mount Endpoints::Rules
      mount Endpoints::Tags

      add_swagger_documentation(api_version: "v1", info: {title: "Mihari API"})
    end
  end
end
