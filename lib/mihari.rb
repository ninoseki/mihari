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
require "dry/monads"
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

require "mihari/config"

# Mixins
require "mihari/mixins/autonomous_system"
require "mihari/mixins/configurable"
require "mihari/mixins/falsepositive"
require "mihari/mixins/error_notification"
require "mihari/mixins/refang"
require "mihari/mixins/retriable"

module Mihari
  class << self
    include Memist::Memoizable

    def emitters
      []
    end
    memoize :emitters

    #
    # @return [Hash<String, Mihari::Enrichers::Base>]
    #
    def emitter_to_class
      @emitter_to_class ||= emitters.flat_map do |klass|
        klass.class_keys.map { |key| [key, klass] }
      end.to_h
    end

    def analyzers
      []
    end
    memoize :analyzers

    #
    # @return [Hash<String, Mihari::Analyzers::Base>]
    #
    def analyzer_to_class
      @analyzer_to_class ||= analyzers.flat_map do |klass|
        klass.class_keys.map { |key| [key, klass] }
      end.to_h
    end

    def enrichers
      []
    end
    memoize :enrichers

    #
    # @return [Hash<String, Mihari::Enrichers::Base>]
    #
    def enricher_to_class
      @enricher_to_class ||= enrichers.flat_map do |klass|
        klass.class_keys.map { |key| [key, klass] }
      end.to_h
    end

    def config
      @config ||= Config.new
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

# Core classes
require "mihari/actor"
require "mihari/database"
require "mihari/http"
require "mihari/type_checker"
require "mihari/rule"

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
require "mihari/clients/hunterhow"
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
require "mihari/analyzers/hunterhow"
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

# Types
require "mihari/types"

# Constants
require "mihari/constants"

# Structs
require "mihari/structs/binaryedge"
require "mihari/structs/censys"
require "mihari/structs/config"
require "mihari/structs/filters"
require "mihari/structs/google_public_dns"
require "mihari/structs/greynoise"
require "mihari/structs/ipinfo"
require "mihari/structs/hunterhow"
require "mihari/structs/onyphe"
require "mihari/structs/shodan"
require "mihari/structs/urlscan"
require "mihari/structs/virustotal_intelligence"

# Schemas
require "mihari/schemas/macros"
require "mihari/schemas/mixins"

require "mihari/schemas/options"

require "mihari/schemas/alert"
require "mihari/schemas/analyzer"
require "mihari/schemas/rule"

# Services
require "mihari/services/rule_builder"
require "mihari/services/rule_runner"

require "mihari/services/alert_builder"
require "mihari/services/alert_proxy"
require "mihari/services/alert_runner"

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
