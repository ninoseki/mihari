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
require "mihari/mixins/falsepositive"
require "mihari/mixins/error_notification"
require "mihari/mixins/refang"
require "mihari/mixins/retriable"

module Mihari
  class Config
    # @return [String, nil]
    attr_reader :binaryedge_api_key

    # @return [String, nil]
    attr_reader :censys_id

    # @return [String, nil]
    attr_reader :censys_secret

    # @return [String, nil]
    attr_reader :circl_passive_password

    # @return [String, nil]
    attr_reader :circl_passive_username

    # @return [URI]
    attr_reader :database_url

    # @return [String, nil]
    attr_reader :greynoise_api_key

    # @return [String, nil]
    attr_reader :ipinfo_api_key

    # @return [String, nil]
    attr_reader :misp_url

    # @return [String, nil]
    attr_reader :misp_api_key

    # @return [String, nil]
    attr_reader :onyphe_api_key

    # @return [String, nil]
    attr_reader :otx_api_key

    # @return [String, nil]
    attr_reader :passivetotal_api_key

    # @return [String, nil]
    attr_reader :passivetotal_username

    # @return [String, nil]
    attr_reader :pulsedive_api_key

    # @return [String, nil]
    attr_reader :securitytrails_api_key

    # @return [String, nil]
    attr_reader :shodan_api_key

    # @return [String, nil]
    attr_reader :slack_channel

    # @return [String, nil]
    attr_reader :slack_webhook_url

    # @return [String, nil]
    attr_reader :thehive_url

    # @return [String, nil]
    attr_reader :thehive_api_key

    # @return [String, nil]
    attr_reader :thehive_api_version

    # @return [String, nil]
    attr_reader :urlscan_api_key

    # @return [String, nil]
    attr_reader :virustotal_api_key

    # @return [String, nil]
    attr_reader :zoomeye_api_key

    # @return [String, nil]
    attr_reader :sentry_dsn

    # @return [String, nil]
    attr_reader :hide_config_values

    def initialize
      @binaryedge_api_key = ENV.fetch("BINARYEDGE_API_KEY", nil)

      @censys_id = ENV.fetch("CENSYS_ID", nil)
      @censys_secret = ENV.fetch("CENSYS_SECRET", nil)

      @circl_passive_password = ENV.fetch("CIRCL_PASSIVE_PASSWORD", nil)
      @circl_passive_username = ENV.fetch("CIRCL_PASSIVE_USERNAME", nil)

      @database_url = URI(ENV.fetch("DATABASE_URL", "sqlite3:///mihari.db"))

      @greynoise_api_key = ENV.fetch("GREYNOISE_API_KEY", nil)

      @ipinfo_api_key = ENV.fetch("IPINFO_API_KEY", nil)

      @misp_url = ENV.fetch("MISP_URL", nil)
      @misp_api_key = ENV.fetch("MISP_API_KEY", nil)

      @onyphe_api_key = ENV.fetch("ONYPHE_API_KEY", nil)

      @otx_api_key = ENV.fetch("OTX_API_KEY", nil)

      @passivetotal_api_key = ENV.fetch("PASSIVETOTAL_API_KEY", nil)
      @passivetotal_username = ENV.fetch("PASSIVETOTAL_USERNAME", nil)

      @pulsedive_api_key = ENV.fetch("PULSEDIVE_API_KEY", nil)

      @securitytrails_api_key = ENV.fetch("SECURITYTRAILS_API_KEY", nil)

      @shodan_api_key = ENV.fetch("SHODAN_API_KEY", nil)

      @slack_channel = ENV.fetch("SLACK_CHANNEL", nil)
      @slack_webhook_url = ENV.fetch("SLACK_WEBHOOK_URL", nil)

      @thehive_url = ENV.fetch("THEHIVE_URL", nil)
      @thehive_api_key = ENV.fetch("THEHIVE_API_KEY", nil)
      @thehive_api_version = ENV.fetch("THEHIVE_API_VERSION", nil)

      @urlscan_api_key = ENV.fetch("URLSCAN_API_KEY", nil)

      @virustotal_api_key = ENV.fetch("VIRUSTOTAL_API_KEY", nil)

      @zoomeye_api_key = ENV.fetch("ZOOMEYE_API_KEY", nil)

      @sentry_dsn = ENV.fetch("SENTRY_DSN", nil)

      @hide_config_values = ENV.fetch("HIDE_CONFIG_VALUES", false)
    end
  end

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

    def config
      @config ||= Config.new
    end

    def configs
      (Mihari.analyzers + Mihari.emitters + Mihari.enrichers).map do |klass|
        Mihari::Structs::Config.from_class(klass)
      end.compact
    end

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
require "mihari/structs/censys"
require "mihari/structs/config"
require "mihari/structs/filters"
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
require "mihari/emitters/misp"
require "mihari/emitters/slack"
require "mihari/emitters/the_hive"
require "mihari/emitters/webhook"

# Clients
require "mihari/clients/base"

require "mihari/clients/binaryedge"
require "mihari/clients/censys"
require "mihari/clients/circl"
require "mihari/clients/crtsh"
require "mihari/clients/dnstwister"
require "mihari/clients/greynoise"
require "mihari/clients/misp"
require "mihari/clients/onyphe"
require "mihari/clients/otx"
require "mihari/clients/passivetotal"
require "mihari/clients/publsedive"
require "mihari/clients/securitytrails"
require "mihari/clients/shodan"
require "mihari/clients/the_hive"
require "mihari/clients/urlscan"
require "mihari/clients/virustotal"
require "mihari/clients/zoomeye"

# Analyzers
require "mihari/analyzers/base"

require "mihari/analyzers/binaryedge"
require "mihari/analyzers/censys"
require "mihari/analyzers/circl"
require "mihari/analyzers/crtsh"
require "mihari/analyzers/dnstwister"
require "mihari/analyzers/feed"
require "mihari/analyzers/greynoise"
require "mihari/analyzers/onyphe"
require "mihari/analyzers/otx"
require "mihari/analyzers/passivetotal"
require "mihari/analyzers/pulsedive"
require "mihari/analyzers/securitytrails"
require "mihari/analyzers/shodan"
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
require "mihari/entities/tag"
require "mihari/entities/whois"

require "mihari/entities/artifact"

require "mihari/entities/alert"

require "mihari/entities/rule"

# Web app
require "mihari/web/app"

# CLIs
require "mihari/cli/main"

# initialize Sentry
Mihari.initialize_sentry
