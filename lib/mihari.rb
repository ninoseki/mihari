# frozen_string_literal: true

# standard libs
require "ipaddr"
require "json"
require "net/http"
require "net/https"
require "resolv"
require "yaml"

# Active Support & Active Record
require "active_support"

require "active_support/core_ext/hash"
require "active_support/core_ext/integer/time"
require "active_support/core_ext/numeric/time"
require "active_support/core_ext/object/deep_dup"

require "active_record"

# dry-rb
require "dry/configurable"
require "dry/files"
require "dry/initializer"
require "dry/schema"
require "dry/struct"
require "dry/types"
require "dry/validation"

# Grape
require "grape"
require "grape-entity"

# Other utility libs
require "addressable/uri"
require "awrence"
require "email_address"
require "memist"
require "net/ping"
require "parallel"
require "plissken"
require "public_suffix"
require "semantic_logger"
require "sentry-ruby"
require "uuidtools"

# Load .env
require "dotenv/load"

# Mihari
require "mihari/version"
require "mihari/errors"

# Mixins
require "mihari/mixins/autonomous_system"
require "mihari/mixins/configurable"
require "mihari/mixins/database"
require "mihari/mixins/disallowed_data_value"
require "mihari/mixins/error_notification"
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
  setting :sentry_dsn, default: ENV["SENTRY_DSN"]

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

    def logger
      SemanticLogger.default_level = :info
      SemanticLogger.add_appender(io: $stderr, formatter: :color)
      SemanticLogger["Mihari"]
    end
    memoize :logger

    def initialize_sentry
      return if Mihari.config.sentry_dsn.nil?
      return if Sentry.initialized?

      Sentry.init do |config|
        config.dsn = Mihari.config.sentry_dsn

        config.traces_sample_rate = 0.5
      end
    end
  end
end

require "mihari/database"
require "mihari/type_checker"

require "mihari/http"

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
require "mihari/structs/rule"
require "mihari/structs/shodan"
require "mihari/structs/urlscan"
require "mihari/structs/virustotal_intelligence"

# Schemas
require "mihari/schemas/macros"

require "mihari/schemas/analyzer"
require "mihari/schemas/rule"

# Enrichers
require "mihari/enrichers/base"
require "mihari/enrichers/ipinfo"
require "mihari/enrichers/shodan"

# Models
require "mihari/models/alert"
require "mihari/models/artifact"
require "mihari/models/autonomous_system"
require "mihari/models/cpe"
require "mihari/models/dns"
require "mihari/models/geolocation"
require "mihari/models/port"
require "mihari/models/reverse_dns"
require "mihari/models/rule"
require "mihari/models/tag"
require "mihari/models/tagging"
require "mihari/models/whois"

# Emitters
require "mihari/emitters/base"

require "mihari/emitters/database"
require "mihari/emitters/http"
require "mihari/emitters/misp"
require "mihari/emitters/slack"
require "mihari/emitters/the_hive"
require "mihari/emitters/webhook"

# Analyzers
require "mihari/analyzers/base"

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

# Entities
require "mihari/entities/message"

require "mihari/entities/autonomous_system"
require "mihari/entities/command"
require "mihari/entities/config"
require "mihari/entities/cpe"
require "mihari/entities/dns"
require "mihari/entities/geolocation"
require "mihari/entities/ip_address"
require "mihari/entities/port"
require "mihari/entities/reverse_dns"
require "mihari/entities/source"
require "mihari/entities/tag"
require "mihari/entities/whois"

require "mihari/entities/artifact"

require "mihari/entities/alert"

require "mihari/entities/rule"

# Status checker
require "mihari/status"

# Web app
require "mihari/web/app"

# CLIs
require "mihari/cli/main"

# initialize Sentry
Mihari.initialize_sentry
