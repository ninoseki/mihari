# frozen_string_literal: true

# Entities
require "mihari/web/entities/message"

require "mihari/web/entities/autonomous_system"
require "mihari/web/entities/command"
require "mihari/web/entities/config"
require "mihari/web/entities/dns"
require "mihari/web/entities/geolocation"
require "mihari/web/entities/ip_address"
require "mihari/web/entities/reverse_dns"
require "mihari/web/entities/source"
require "mihari/web/entities/tag"
require "mihari/web/entities/whois"

require "mihari/web/entities/artifact"

require "mihari/web/entities/alert"

require "mihari/web/entities/rule"

# Endpoints
require "mihari/web/endpoints/alerts"
require "mihari/web/endpoints/artifacts"
require "mihari/web/endpoints/command"
require "mihari/web/endpoints/configs"
require "mihari/web/endpoints/ip_addresses"
require "mihari/web/endpoints/rules"
require "mihari/web/endpoints/sources"
require "mihari/web/endpoints/tags"

module Mihari
  class API < Grape::API
    prefix "api"
    format :json

    mount Endpoints::Alerts
    mount Endpoints::Artifacts
    mount Endpoints::Command
    mount Endpoints::Configs
    mount Endpoints::IPAddresses
    mount Endpoints::Rules
    mount Endpoints::Sources
    mount Endpoints::Tags

    add_swagger_documentation(api_version: "v1", info: { title: "Mihari API" })
  end
end
