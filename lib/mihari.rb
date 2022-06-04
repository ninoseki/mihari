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

  setting :binaryedge_api_key, default: ENV.fetch("BINARYEDGE_API_KEY", nil)

  setting :censys_id, default: ENV.fetch("CENSYS_ID", nil)
  setting :censys_secret, default: ENV.fetch("CENSYS_SECRET", nil)

  setting :circl_passive_password, default: ENV.fetch("CIRCL_PASSIVE_PASSWORD", nil)
  setting :circl_passive_username, default: ENV.fetch("CIRCL_PASSIVE_USERNAME", nil)

  setting :database, default: ENV.fetch("DATABASE", "mihari.db")

  setting :greynoise_api_key, default: ENV.fetch("GREYNOISE_API_KEY", nil)

  setting :ipinfo_api_key, default: ENV.fetch("IPINFO_API_KEY", nil)

  setting :misp_api_endpoint, default: ENV.fetch("MISP_API_ENDPOINT", nil)
  setting :misp_api_key, default: ENV.fetch("MISP_API_KEY", nil)

  setting :onyphe_api_key, default: ENV.fetch("ONYPHE_API_KEY", nil)

  setting :otx_api_key, default: ENV.fetch("OTX_API_KEY", nil)

  setting :passivetotal_api_key, default: ENV.fetch("PASSIVETOTAL_API_KEY", nil)
  setting :passivetotal_username, default: ENV.fetch("PASSIVETOTAL_USERNAME", nil)

  setting :pulsedive_api_key, default: ENV.fetch("PULSEDIVE_API_KEY", nil)

  setting :securitytrails_api_key, default: ENV.fetch("SECURITYTRAILS_API_KEY", nil)

  setting :shodan_api_key, default: ENV.fetch("SHODAN_API_KEY", nil)

  setting :slack_channel, default: ENV.fetch("SLACK_CHANNEL", nil)
  setting :slack_webhook_url, default: ENV.fetch("SLACK_WEBHOOK_URL", nil)

  setting :spyse_api_key, default: ENV.fetch("SPYSE_API_KEY", nil)

  setting :thehive_api_endpoint, default: ENV.fetch("THEHIVE_API_ENDPOINT", nil)
  setting :thehive_api_key, default: ENV.fetch("THEHIVE_API_KEY", nil)
  setting :thehive_api_version, default: ENV.fetch("THEHIVE_API_VERSION", nil)

  setting :urlscan_api_key, default: ENV.fetch("URLSCAN_API_KEY", nil)

  setting :virustotal_api_key, default: ENV.fetch("VIRUSTOTAL_API_KEY", nil)

  setting :webhook_url, default: ENV.fetch("WEBHOOK_URL", nil)
  setting :webhook_use_json_body, constructor: ->(value = ENV.fetch("WEBHOOK_USE_JSON_BODY", nil)) { truthy?(value) }

  setting :zoomeye_api_key, default: ENV.fetch("ZOOMEYE_API_KEY", nil)

  setting :sentry_dsn, default: ENV.fetch("SENTRY_DSN", nil)

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
require "mihari/structs/google_public_dns"
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
require "mihari/enrichers/google_public_dns"
require "mihari/enrichers/ipinfo"
require "mihari/enrichers/shodan"
require "mihari/enrichers/whois"

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
