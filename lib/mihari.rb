# frozen_string_literal: true

require "awrence"
require "colorize"
require "dry/configurable"
require "dry/files"
require "memist"
require "plissken"
require "yaml"

# Load .env
require "dotenv/load"

# Mixins
require "mihari/mixins/autonomous_system"
require "mihari/mixins/configurable"
require "mihari/mixins/database"
require "mihari/mixins/disallowed_data_value"
require "mihari/mixins/hash"
require "mihari/mixins/refang"
require "mihari/mixins/retriable"
require "mihari/mixins/rule"

def truthy?(value)
  return true if value == "true"
  return true if value == true

  false
end

module Mihari
  extend Dry::Configurable

  setting :binaryedge_api_key, default: ENV["BINARYEDGE_API_KEY"]
  setting :censys_id, default: ENV["CENSYS_ID"]
  setting :censys_secret, default: ENV["CENSYS_SECRET"]
  setting :circl_passive_password, default: ENV["CIRCL_PASSIVE_PASSWORD"]
  setting :circl_passive_username, default: ENV["CIRCL_PASSIVE_USERNAME"]
  setting :database, default: ENV["DATABASE"] || "mihari.db"
  setting :greynoise_api_key, default: ENV["GREYNOISE_API_KEY"]
  setting :ipinfo_api_key, default: ENV["IPINFO_API_KEY"]
  setting :misp_api_endpoint, default: ENV["MISP_API_ENDPOINT"]
  setting :misp_api_key, default: ENV["MISP_API_KEY"]
  setting :onyphe_api_key, default: ENV["ONYPHE_API_KEY"]
  setting :otx_api_key, default: ENV["OTX_API_KEY"]
  setting :passivetotal_api_key, default: ENV["PASSIVETOTAL_API_KEY"]
  setting :passivetotal_username, default: ENV["PASSIVETOTAL_USERNAME"]
  setting :pulsedive_api_key, default: ENV["PULSEDIVE_API_KEY"]
  setting :securitytrails_api_key, default: ENV["SECURITYTRAILS_API_KEY"]
  setting :shodan_api_key, default: ENV["SHODAN_API_KEY"]
  setting :slack_channel, default: ENV["SLACK_CHANNEL"]
  setting :slack_webhook_url, default: ENV["SLACK_WEBHOOK_URL"]
  setting :spyse_api_key, default: ENV["SPYSE_API_KEY"]
  setting :thehive_api_endpoint, default: ENV["THEHIVE_API_ENDPOINT"]
  setting :thehive_api_key, default: ENV["THEHIVE_API_KEY"]
  setting :urlscan_api_key, default: ENV["URLSCAN_API_KEY"]
  setting :virustotal_api_key, default: ENV["VIRUSTOTAL_API_KEY"]
  setting :webhook_url, default: ENV["WEBHOOK_URL"]
  setting :webhook_use_json_body, constructor: ->(value = ENV["WEBHOOK_USE_JSON_BODY"]) { truthy?(value) }
  setting :zoomeye_api_key, default: ENV["ZOOMEYE_API_KEY"]

  class << self
    include Memist::Memoizable

    def emitters
      []
    end
    memoize :emitters

    def analyzers
      []
    end
    memoize :analyzers

    def enrichers
      []
    end
    memoize :enrichers
  end
end

require "mihari/version"
require "mihari/errors"

require "mihari/database"
require "mihari/type_checker"

# Constants
require "mihari/constants"

# Types
require "mihari/types"

# Structs
require "mihari/structs/alert"
require "mihari/structs/censys"
require "mihari/structs/greynoise"
require "mihari/structs/ipinfo"
require "mihari/structs/onyphe"
require "mihari/structs/shodan"
require "mihari/structs/urlscan"
require "mihari/structs/virustotal_intelligence"

# Schemas
require "mihari/schemas/analyzer"
require "mihari/schemas/rule"

# Enrichers
require "mihari/enrichers/base"
require "mihari/enrichers/ipinfo"

# Models
require "mihari/models/alert"
require "mihari/models/artifact"
require "mihari/models/autonomous_system"
require "mihari/models/dns"
require "mihari/models/geolocation"
require "mihari/models/reverse_dns"
require "mihari/models/tag"
require "mihari/models/tagging"
require "mihari/models/whois"

# Analyzers
require "mihari/analyzers/base"
require "mihari/analyzers/basic"

require "mihari/analyzers/binaryedge"
require "mihari/analyzers/censys"
require "mihari/analyzers/circl"
require "mihari/analyzers/crtsh"
require "mihari/analyzers/dnpedia"
require "mihari/analyzers/dnstwister"
require "mihari/analyzers/feed"
require "mihari/analyzers/greynoise"
require "mihari/analyzers/onyphe"
require "mihari/analyzers/otx"
require "mihari/analyzers/passivetotal"
require "mihari/analyzers/pulsedive"
require "mihari/analyzers/securitytrails"
require "mihari/analyzers/shodan"
require "mihari/analyzers/spyse"
require "mihari/analyzers/urlscan"
require "mihari/analyzers/virustotal_intelligence"
require "mihari/analyzers/virustotal"
require "mihari/analyzers/zoomeye"
require "mihari/analyzers/rule"

# Notifiers
require "mihari/notifiers/base"
require "mihari/notifiers/slack"
require "mihari/notifiers/exception_notifier"

# Emitters
require "mihari/emitters/base"
require "mihari/emitters/database"
require "mihari/emitters/misp"
require "mihari/emitters/slack"
require "mihari/emitters/stdout"
require "mihari/emitters/the_hive"
require "mihari/emitters/webhook"

# Status checker
require "mihari/status"

# Web app
require "mihari/web/app"

# CLIs
require "mihari/cli/main"
